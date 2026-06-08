import json
import subprocess
import threading
import time
import urllib.request


OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
MODEL = "qwen3:8b"


def run_command(args, timeout=10):
    try:
        completed = subprocess.run(
            args,
            capture_output=True,
            text=True,
            timeout=timeout,
            encoding="utf-8",
            errors="replace",
        )
        return completed.stdout.strip()
    except Exception:
        return ""


def powershell_int(command):
    output = run_command(
        [
            "powershell",
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-Command",
            command,
        ]
    )
    try:
        return int(float(output.replace(",", "").strip()))
    except Exception:
        return 0


def gpu_snapshot():
    output = run_command(
        [
            "nvidia-smi",
            "--query-gpu=memory.used,memory.free,utilization.gpu",
            "--format=csv,noheader,nounits",
        ]
    )
    if not output:
        return {"vram_used_mb": None, "vram_free_mb": None, "gpu_util_percent": None}
    first = output.splitlines()[0]
    parts = [part.strip() for part in first.split(",")]
    try:
        return {
            "vram_used_mb": int(float(parts[0])),
            "vram_free_mb": int(float(parts[1])),
            "gpu_util_percent": int(float(parts[2])),
        }
    except Exception:
        return {"vram_used_mb": None, "vram_free_mb": None, "gpu_util_percent": None}


def sample_resources(total_ram_bytes):
    ollama_ws = powershell_int(
        "(Get-Process -Name ollama -ErrorAction SilentlyContinue | "
        "Measure-Object -Property WorkingSet64 -Sum).Sum"
    )
    free_kb = powershell_int("(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory")
    gpu = gpu_snapshot()
    used_ram_gb = None
    free_ram_gb = None
    if free_kb:
        free_ram_gb = round((free_kb * 1024) / (1024**3), 3)
        used_ram_gb = round((total_ram_bytes - free_kb * 1024) / (1024**3), 3)
    return {
        "timestamp": time.time(),
        "ollama_working_set_mb": round(ollama_ws / (1024**2), 2) if ollama_ws else 0,
        "system_ram_used_gb": used_ram_gb,
        "system_ram_free_gb": free_ram_gb,
        **gpu,
    }


def generate(prompt, num_predict):
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False,
        "think": False,
        "keep_alive": "10m",
        "options": {
            "temperature": 0.6,
            "num_predict": num_predict,
            "num_ctx": 2048,
        },
    }
    request = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=900) as response:
        return json.loads(response.read().decode("utf-8"))


def summarize_samples(samples):
    if not samples:
        return {}

    def numeric_values(key):
        return [sample[key] for sample in samples if sample.get(key) is not None]

    summary = {}
    for key in [
        "ollama_working_set_mb",
        "system_ram_used_gb",
        "system_ram_free_gb",
        "vram_used_mb",
        "vram_free_mb",
        "gpu_util_percent",
    ]:
        values = numeric_values(key)
        if values:
            summary[f"{key}_min"] = min(values)
            summary[f"{key}_max"] = max(values)
            summary[f"{key}_last"] = values[-1]
    return summary


def run_case(name, prompt, num_predict):
    total_ram = powershell_int("(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory")
    result = {"name": name, "prompt": prompt}
    samples = []
    holder = {"response": None, "error": None}

    def worker():
        try:
            holder["response"] = generate(prompt, num_predict)
        except Exception as exc:
            holder["error"] = repr(exc)

    thread = threading.Thread(target=worker, daemon=True)
    start = time.perf_counter()
    thread.start()
    while thread.is_alive():
        samples.append(sample_resources(total_ram))
        time.sleep(1.0)
    thread.join()
    samples.append(sample_resources(total_ram))
    elapsed = time.perf_counter() - start

    result["wall_seconds"] = round(elapsed, 3)
    result["sample_count"] = len(samples)
    result["resource_summary"] = summarize_samples(samples)

    if holder["error"]:
        result["error"] = holder["error"]
        return result

    response = holder["response"] or {}
    result["ollama_total_seconds"] = round(response.get("total_duration", 0) / 1e9, 3)
    result["ollama_load_seconds"] = round(response.get("load_duration", 0) / 1e9, 3)
    result["prompt_eval_count"] = response.get("prompt_eval_count")
    result["eval_count"] = response.get("eval_count")
    result["tokens_per_second"] = None
    if response.get("eval_count") and response.get("eval_duration"):
        result["tokens_per_second"] = round(response["eval_count"] / (response["eval_duration"] / 1e9), 2)
    text = response.get("response", "")
    result["response_chars"] = len(text)
    result["response_preview"] = text[:600]
    return result


def main():
    cases = [
        {
            "name": "cold_short_response",
            "prompt": "Responde en una frase corta: sistema local listo para Valentina Sol.",
            "num_predict": 80,
        },
        {
            "name": "warm_content_generation",
            "prompt": (
                "Genera 5 ideas breves de TikTok para una influencer virtual IA "
                "de lifestyle llamada Valentina Sol. Formato numerado, maximo 12 palabras por idea."
            ),
            "num_predict": 180,
        },
    ]
    report = {
        "model": MODEL,
        "created_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "cases": [run_case(**case) for case in cases],
    }
    print(json.dumps(report, indent=2, ensure_ascii=True))


if __name__ == "__main__":
    main()
