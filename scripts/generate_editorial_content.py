import argparse
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request
import uuid
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
MODEL = "qwen3:8b"
CHARACTER_SLUG = "valentina-sol"
CHARACTER_NAME = "Valentina Sol"
CATEGORIES = ["playa", "cafeteria", "gym", "viajes", "lifestyle"]

PROMPT_CONFIG = {
    "tiktok_idea": {
        "count": 20,
        "platform": "TikTok",
        "body_key": "description",
        "title_key": "title",
        "instruction": (
            "Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: "
            "title, category, description, visual_scene, cta. Usa categorias repartidas entre "
            "playa, cafeteria, gym, viajes y lifestyle."
        ),
    },
    "caption": {
        "count": 20,
        "platform": "Instagram/TikTok",
        "body_key": "caption",
        "title_key": "mood",
        "instruction": (
            "Genera captions listos para publicar. Cada item debe tener: category, caption, "
            "hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas."
        ),
    },
    "hook": {
        "count": 20,
        "platform": "TikTok",
        "body_key": "hook",
        "title_key": "angle",
        "instruction": (
            "Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, "
            "angle, format. Deben abrir curiosidad sin clickbait agresivo."
        ),
    },
    "story": {
        "count": 20,
        "platform": "Instagram Stories",
        "body_key": "story",
        "title_key": "title",
        "instruction": (
            "Genera historias cortas para stories. Cada item debe tener: title, category, "
            "story, frames, cta. Frames debe ser un arreglo de 3 textos breves."
        ),
    },
}


def read_text(path):
    return (ROOT / path).read_text(encoding="utf-8").strip()


def parse_env(path):
    values = {}
    for line in (ROOT / path).read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def request_ollama(prompt, system_prompt, temperature):
    payload = {
        "model": MODEL,
        "system": system_prompt,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "think": False,
        "options": {
            "temperature": temperature,
            "top_p": 0.9,
            "num_ctx": 8192,
        },
    }
    data = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(
        OLLAMA_URL,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=600) as response:
        return json.loads(response.read().decode("utf-8"))


def extract_json(text):
    text = text.strip()
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass
    match = re.search(r"\{.*\}", text, flags=re.DOTALL)
    if not match:
        raise ValueError("No JSON object found in model response")
    return json.loads(match.group(0))


def normalize_category(value, index):
    value = (value or "").strip().lower()
    value = value.replace("cafe", "cafeteria")
    value = value.replace("cafeteriaa", "cafeteria")
    value = value.replace("viaje", "viajes")
    value = value.replace("vida diaria", "lifestyle")
    if value not in CATEGORIES:
        return CATEGORIES[index % len(CATEGORIES)]
    return value


def ensure_text(value):
    if isinstance(value, list):
        return " | ".join(str(item).strip() for item in value if str(item).strip())
    if value is None:
        return ""
    return str(value).strip()


def build_generation_prompt(content_type, count):
    config = PROMPT_CONFIG[content_type]
    return f"""
Devuelve exclusivamente JSON valido con esta forma:
{{
  "items": [
    {{
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }}
  ]
}}

Cantidad exacta: {count} items.
Personaje: {CHARACTER_NAME}.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: {config['instruction']}

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.
""".strip()


def generate_content_type(content_type, system_prompt, temperature):
    expected = PROMPT_CONFIG[content_type]["count"]
    items = []
    attempts = 0
    raw_responses = []
    while len(items) < expected and attempts < 3:
        missing = expected - len(items)
        prompt = build_generation_prompt(content_type, missing)
        started = time.perf_counter()
        response = request_ollama(prompt, system_prompt, temperature)
        elapsed = round(time.perf_counter() - started, 3)
        raw_text = response.get("response", "")
        data = extract_json(raw_text)
        batch = data.get("items", data if isinstance(data, list) else [])
        if not isinstance(batch, list):
            raise ValueError(f"Invalid items payload for {content_type}")
        raw_responses.append(
            {
                "attempt": attempts + 1,
                "elapsed_seconds": elapsed,
                "response_tokens": response.get("eval_count"),
                "items_returned": len(batch),
            }
        )
        for item in batch:
            if isinstance(item, dict):
                items.append(item)
            if len(items) >= expected:
                break
        attempts += 1
    if len(items) < expected:
        raise RuntimeError(f"{content_type} generated {len(items)} of {expected} items")
    return items[:expected], raw_responses


def sql_literal(value):
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"


def sql_json(value):
    return sql_literal(json.dumps(value, ensure_ascii=True)) + "::jsonb"


def normalize_rows(run_id, generated, prompt_snapshots):
    rows = []
    for content_type, items in generated.items():
        config = PROMPT_CONFIG[content_type]
        for index, item in enumerate(items):
            category = normalize_category(item.get("category"), index)
            body = ensure_text(item.get(config["body_key"]))
            if not body and content_type == "story":
                body = ensure_text(item.get("frames"))
            title = ensure_text(item.get(config["title_key"]))
            if not title:
                title = f"{content_type} {index + 1:02d}"
            metadata = {
                "ordinal": index + 1,
                "raw": item,
                "prompt_type": content_type,
            }
            rows.append(
                {
                    "run_id": str(run_id),
                    "character_slug": CHARACTER_SLUG,
                    "content_type": content_type,
                    "category": category,
                    "platform": config["platform"],
                    "title": title,
                    "body": body,
                    "source_model": MODEL,
                    "prompt": prompt_snapshots[content_type],
                    "metadata": metadata,
                    "status": "draft",
                }
            )
    return rows


def write_sql(sql_path, run_id, actual_counts, rows):
    requested_counts = {key: value["count"] for key, value in PROMPT_CONFIG.items()}
    metadata = {
        "phase": 7,
        "generator": "scripts/generate_editorial_content.py",
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    lines = [
        "\\set ON_ERROR_STOP on",
        "\\i database/schema.sql",
        "",
        "INSERT INTO content_generation_runs (id, character_slug, source_model, prompt_set, requested_counts, actual_counts, metadata)",
        "VALUES (",
        f"  {sql_literal(str(run_id))}::uuid,",
        f"  {sql_literal(CHARACTER_SLUG)},",
        f"  {sql_literal(MODEL)},",
        "  'fase7_initial_editorial_batch',",
        f"  {sql_json(requested_counts)},",
        f"  {sql_json(actual_counts)},",
        f"  {sql_json(metadata)}",
        ");",
        "",
    ]
    for row in rows:
        lines.extend(
            [
                "INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)",
                "VALUES (",
                f"  {sql_literal(str(row['run_id']))}::uuid,",
                f"  {sql_literal(row['character_slug'])},",
                f"  {sql_literal(row['content_type'])},",
                f"  {sql_literal(row['category'])},",
                f"  {sql_literal(row['platform'])},",
                f"  {sql_literal(row['title'])},",
                f"  {sql_literal(row['body'])},",
                f"  {sql_literal(row['source_model'])},",
                f"  {sql_literal(row['prompt'])},",
                f"  {sql_json(row['metadata'])},",
                f"  {sql_literal(row['status'])}",
                ");",
                "",
            ]
        )
    sql_path.write_text("\n".join(lines), encoding="utf-8")


def run_psql(psql_path, env_values, sql_path):
    env = os.environ.copy()
    env["PGPASSWORD"] = env_values["POSTGRES_PASSWORD"]
    command = [
        str(psql_path),
        "-h",
        env_values.get("POSTGRES_HOST", "127.0.0.1"),
        "-p",
        env_values.get("POSTGRES_PORT", "5432"),
        "-U",
        env_values["POSTGRES_USER"],
        "-d",
        env_values["POSTGRES_DB"],
        "-v",
        "ON_ERROR_STOP=1",
        "-f",
        str(sql_path),
    ]
    return subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True)


def parse_args():
    parser = argparse.ArgumentParser(description="Generate editorial content with Ollama and store it in PostgreSQL.")
    parser.add_argument("--env-file", default="database/.env.postgres.local")
    parser.add_argument("--system-prompt", default="prompts/valentina-sol-llm-system.md")
    parser.add_argument("--batch-json", default="docs/content-batch-valentina-sol.json")
    parser.add_argument("--result-json", default="docs/content-generation-result.json")
    parser.add_argument("--sql-file", default="database/generated-content-valentina-sol.sql")
    parser.add_argument("--psql", default=r"C:\Program Files\PostgreSQL\17\bin\psql.exe")
    parser.add_argument("--temperature", type=float, default=0.75)
    parser.add_argument("--skip-db", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    system_prompt = read_text(args.system_prompt)
    env_values = parse_env(args.env_file)
    run_id = uuid.uuid4()
    generated = {}
    diagnostics = {}
    prompt_snapshots = {}
    started_at = datetime.now(timezone.utc).isoformat()
    print(f"CONTENT_RUN_ID={run_id}", flush=True)

    for content_type in PROMPT_CONFIG:
        prompt_snapshots[content_type] = build_generation_prompt(content_type, PROMPT_CONFIG[content_type]["count"])
        items, raw = generate_content_type(content_type, system_prompt, args.temperature)
        generated[content_type] = items
        diagnostics[content_type] = raw
        print(f"GENERATED {content_type}={len(items)}", flush=True)

    actual_counts = {key: len(value) for key, value in generated.items()}
    rows = normalize_rows(run_id, generated, prompt_snapshots)
    batch_payload = {
        "run_id": str(run_id),
        "character": CHARACTER_NAME,
        "model": MODEL,
        "started_at": started_at,
        "finished_at": datetime.now(timezone.utc).isoformat(),
        "actual_counts": actual_counts,
        "diagnostics": diagnostics,
        "items": rows,
    }
    batch_path = ROOT / args.batch_json
    batch_path.parent.mkdir(parents=True, exist_ok=True)
    batch_path.write_text(json.dumps(batch_payload, indent=2, ensure_ascii=True), encoding="utf-8")

    sql_path = ROOT / args.sql_file
    sql_path.parent.mkdir(parents=True, exist_ok=True)
    write_sql(sql_path, run_id, actual_counts, rows)

    psql_result = None
    if not args.skip_db:
        psql_result = run_psql(Path(args.psql), env_values, sql_path)
        if psql_result.returncode != 0:
            print(psql_result.stdout, flush=True)
            print(psql_result.stderr, flush=True)
            raise RuntimeError(f"psql failed with exit code {psql_result.returncode}")

    result = {
        "run_id": str(run_id),
        "rows_prepared": len(rows),
        "actual_counts": actual_counts,
        "batch_json": args.batch_json,
        "sql_file": args.sql_file,
        "inserted_to_postgres": not args.skip_db,
        "psql_stdout": psql_result.stdout if psql_result else "",
        "psql_stderr": psql_result.stderr if psql_result else "",
        "finished_at": datetime.now(timezone.utc).isoformat(),
    }
    result_path = ROOT / args.result_json
    result_path.parent.mkdir(parents=True, exist_ok=True)
    result_path.write_text(json.dumps(result, indent=2, ensure_ascii=True), encoding="utf-8")
    print(f"ROWS_PREPARED={len(rows)}", flush=True)
    print(f"RESULT_JSON={args.result_json}", flush=True)


if __name__ == "__main__":
    try:
        main()
    except (urllib.error.URLError, RuntimeError, ValueError, subprocess.SubprocessError) as exc:
        print(json.dumps({"error": repr(exc)}, indent=2, ensure_ascii=True), flush=True)
        sys.exit(1)
