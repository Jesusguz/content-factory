import argparse
import json
import math
import os
import subprocess
import uuid
from datetime import datetime, timezone
from pathlib import Path

import cv2
import mediapipe as mp
import numpy as np
import torch
from facenet_pytorch import InceptionResnetV1, MTCNN
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
CHARACTER_SLUG = "elena-voss"
DEFAULT_LORA = "models/loras/elena_voss_v1.safetensors"
QUALITY_TARGETS = {
    "face": 90.0,
    "body": 90.0,
    "style": 85.0,
    "narrative": 85.0,
    "global": 90.0,
    "isi": 90.0,
}
STYLE_DISTANCE_SCALE = 1.0
ALLOWED_CATEGORIES = {
    "playa",
    "cafeteria",
    "fitness",
    "gym",
    "viajes",
    "vida_diaria",
    "lifestyle",
}
FORBIDDEN_TEXT_TERMS = {
    "sunglasses",
    "dark sunglasses",
    "mask",
    "different woman",
    "older woman",
    "teen",
    "supermodel",
    "extreme makeup",
    "logo",
}


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def parse_env(path: Path):
    values = {}
    if not path.exists():
        return values
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"')
    return values


def clamp(value, low=0.0, high=100.0):
    return max(low, min(high, value))


def cosine(a, b):
    denominator = float(np.linalg.norm(a) * np.linalg.norm(b))
    if denominator == 0:
        return 0.0
    return float(np.dot(a, b) / denominator)


def score_from_distance(distance, scale):
    return clamp(100.0 * math.exp(-distance * scale))


def score_from_cosine(similarity):
    # Facenet cosine values are not calibrated to 0-100 directly.
    # 0.55 is treated as weak similarity and 0.90+ as strong identity match.
    return clamp(((similarity - 0.55) / 0.35) * 100.0)


def resolve_image_rows(metadata_path: Path):
    data = load_json(metadata_path)
    if isinstance(data, dict) and "selected" in data:
        rows = data["selected"]
    elif isinstance(data, dict) and "items" in data:
        rows = data["items"]
    elif isinstance(data, list):
        rows = data
    else:
        raise ValueError(f"Unsupported metadata format: {metadata_path}")

    resolved = []
    for index, row in enumerate(rows, start=1):
        image_path_value = (
            row.get("output_path")
            or row.get("image_path")
            or row.get("media_path")
            or row.get("path")
        )
        if not image_path_value:
            continue
        image_path = ROOT / image_path_value
        caption_path = image_path.with_suffix(".txt")
        caption = caption_path.read_text(encoding="utf-8").strip() if caption_path.exists() else ""
        resolved.append(
            {
                "index": index,
                "image_path": image_path,
                "relative_path": image_path.relative_to(ROOT).as_posix(),
                "category": normalize_category(row.get("category") or infer_category(image_path)),
                "prompt": row.get("prompt_positive") or row.get("prompt") or caption,
                "source": row,
            }
        )
    return resolved


def normalize_category(category):
    value = (category or "").strip().lower()
    if value == "gym":
        return "fitness"
    if value == "lifestyle":
        return "vida_diaria"
    return value


def infer_category(path: Path):
    parts = [part.lower() for part in path.parts]
    for category in ALLOWED_CATEGORIES:
        if category in parts:
            return category
    return ""


def image_rgb(path: Path):
    return Image.open(path).convert("RGB")


def face_embedding(image: Image.Image, mtcnn: MTCNN, resnet: InceptionResnetV1):
    face = mtcnn(image)
    if face is None:
        return None
    with torch.no_grad():
        embedding = resnet(face.unsqueeze(0)).squeeze(0).cpu().numpy()
    return embedding


def body_vector(image: Image.Image, pose_model):
    arr = np.array(image)
    result = pose_model.process(arr)
    if not result.pose_landmarks:
        return None, {"pose_landmarks_visible": 0, "pose_visibility": 0.0}

    landmarks = result.pose_landmarks.landmark

    def point(index):
        landmark = landmarks[index]
        if landmark.visibility < 0.45:
            return None
        return np.array([landmark.x, landmark.y], dtype=np.float32), float(landmark.visibility)

    ids = mp.solutions.pose.PoseLandmark
    required = {
        "left_shoulder": point(ids.LEFT_SHOULDER.value),
        "right_shoulder": point(ids.RIGHT_SHOULDER.value),
        "left_hip": point(ids.LEFT_HIP.value),
        "right_hip": point(ids.RIGHT_HIP.value),
        "left_knee": point(ids.LEFT_KNEE.value),
        "right_knee": point(ids.RIGHT_KNEE.value),
        "left_ankle": point(ids.LEFT_ANKLE.value),
        "right_ankle": point(ids.RIGHT_ANKLE.value),
    }
    visible = [item[1] for item in required.values() if item is not None]

    pts = {key: value[0] for key, value in required.items() if value is not None}
    shoulders = [pts.get("left_shoulder"), pts.get("right_shoulder")]
    hips = [pts.get("left_hip"), pts.get("right_hip")]
    knees = [pts.get("left_knee"), pts.get("right_knee")]
    ankles = [pts.get("left_ankle"), pts.get("right_ankle")]
    if any(point is None for point in shoulders + hips):
        return None, {"pose_landmarks_visible": len(visible), "pose_visibility": float(np.mean(visible))}

    shoulder_mid = (shoulders[0] + shoulders[1]) / 2
    hip_mid = (hips[0] + hips[1]) / 2
    body_height = 0.0
    if all(point is not None for point in ankles):
        ankle_mid = (ankles[0] + ankles[1]) / 2
        body_height = float(np.linalg.norm(ankle_mid - shoulder_mid))
    if body_height <= 0:
        body_height = float(np.linalg.norm(hip_mid - shoulder_mid))
    if body_height <= 0:
        return None, {"pose_landmarks_visible": len(visible), "pose_visibility": float(np.mean(visible))}

    shoulder_width = float(np.linalg.norm(shoulders[0] - shoulders[1]))
    hip_width = float(np.linalg.norm(hips[0] - hips[1]))
    torso = float(np.linalg.norm(hip_mid - shoulder_mid))
    left_leg = float(np.linalg.norm(knees[0] - hips[0]) + np.linalg.norm(ankles[0] - knees[0])) if knees[0] is not None and ankles[0] is not None else np.nan
    right_leg = float(np.linalg.norm(knees[1] - hips[1]) + np.linalg.norm(ankles[1] - knees[1])) if knees[1] is not None and ankles[1] is not None else np.nan
    leg_asymmetry = (
        abs(left_leg - right_leg) / max(left_leg + right_leg, 1e-6)
        if np.isfinite(left_leg) and np.isfinite(right_leg)
        else np.nan
    )
    vector = np.array(
        [
            shoulder_width / body_height,
            hip_width / body_height,
            torso / body_height,
            left_leg / body_height if np.isfinite(left_leg) else np.nan,
            right_leg / body_height if np.isfinite(right_leg) else np.nan,
            shoulder_width / max(hip_width, 1e-6),
            leg_asymmetry,
        ],
        dtype=np.float32,
    )
    leg_points_visible = sum(point is not None for point in knees + ankles)
    completeness = clamp((4 + leg_points_visible) / 8.0, 0.0, 1.0)
    return vector, {
        "pose_landmarks_visible": len(visible),
        "pose_visibility": round(float(np.mean(visible)), 4),
        "body_completeness": round(completeness, 4),
        "legs_measured": leg_points_visible >= 3,
    }


def style_vector(image: Image.Image):
    arr = np.array(image)
    hsv = cv2.cvtColor(arr, cv2.COLOR_RGB2HSV)
    hist_h = cv2.calcHist([hsv], [0], None, [16], [0, 180]).flatten()
    hist_s = cv2.calcHist([hsv], [1], None, [16], [0, 256]).flatten()
    hist_v = cv2.calcHist([hsv], [2], None, [16], [0, 256]).flatten()
    hist = np.concatenate([hist_h, hist_s, hist_v]).astype(np.float32)
    hist = hist / max(float(hist.sum()), 1.0)
    mean_rgb = arr.mean(axis=(0, 1)) / 255.0
    std_rgb = arr.std(axis=(0, 1)) / 255.0
    return np.concatenate([hist, mean_rgb, std_rgb]).astype(np.float32)


def narrative_score(row):
    score = 100.0
    prompt = (row.get("prompt") or "").lower()
    category = row.get("category") or ""
    if category not in {normalize_category(item) for item in ALLOWED_CATEGORIES}:
        score -= 18
    if "elena_voss" not in prompt and "elena voss" not in prompt:
        score -= 10
    identity_terms = ["25", "hair", "eyes", "skin", "face", "body"]
    missing_identity_terms = [term for term in identity_terms if term not in prompt]
    score -= min(12, len(missing_identity_terms) * 2)
    for term in FORBIDDEN_TEXT_TERMS:
        if term in prompt:
            score -= 18
    return clamp(score), {
        "category": category,
        "missing_identity_terms": missing_identity_terms,
        "has_trigger": "elena_voss" in prompt or "elena voss" in prompt,
    }


def compute_centroid(vectors):
    if not vectors:
        return None
    return np.nanmean(np.stack(vectors, axis=0), axis=0)


def mean(values):
    return round(float(sum(values) / len(values)), 2) if values else 0.0


def weighted_global(face, body, style, narrative):
    return round(face * 0.40 + body * 0.30 + style * 0.15 + narrative * 0.15, 2)


def weighted_isi(face, body, narrative):
    return round(face * 0.45 + body * 0.35 + narrative * 0.20, 2)


def sql_literal(value):
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"


def sql_json(value):
    return sql_literal(json.dumps(value, ensure_ascii=True)) + "::jsonb"


def write_sql(path: Path, result):
    batch_id = result["batch_id"]
    lines = [
        "\\set ON_ERROR_STOP on",
        "\\i database/schema.sql",
        "",
        "INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)",
        "VALUES (",
        f"  {sql_literal(batch_id)}::uuid,",
        f"  {sql_literal(CHARACTER_SLUG)},",
        f"  {sql_literal(result['batch_name'])},",
        f"  {sql_literal(result['source_metadata'])},",
        f"  {sql_literal(result['lora_path'])},",
        f"  {'true' if result['lora_present'] else 'false'},",
        f"  {result['scores']['face']},",
        f"  {result['scores']['body']},",
        f"  {result['scores']['style']},",
        f"  {result['scores']['narrative']},",
        f"  {result['scores']['global']},",
        f"  {result['scores']['isi']},",
        f"  {'true' if result['approved'] else 'false'},",
        f"  {sql_literal(result['gate_status'])},",
        f"  {sql_json(result['rejection_reasons'])},",
        f"  {sql_json(result['metrics'])}",
        ");",
        "",
    ]
    for item in result["items"]:
        lines.extend(
            [
                "INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)",
                "VALUES (",
                f"  {sql_literal(batch_id)}::uuid,",
                f"  {sql_literal(CHARACTER_SLUG)},",
                f"  {sql_literal(item['image_path'])},",
                f"  {sql_literal(item['category'])},",
                f"  {item['scores']['face']},",
                f"  {item['scores']['body']},",
                f"  {item['scores']['style']},",
                f"  {item['scores']['narrative']},",
                f"  {item['scores']['global']},",
                f"  {'true' if item['approved'] else 'false'},",
                f"  {sql_json(item['metrics'])}",
                ");",
                "",
            ]
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines), encoding="utf-8")


def run_psql(psql_path: Path, env_values, sql_path: Path):
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


def apply_distribution_penalty(rows, narrative_batch_score):
    categories = [row["category"] for row in rows if row["category"]]
    unique = set(categories)
    required = {"playa", "cafeteria", "fitness", "viajes", "vida_diaria"}
    missing = required - unique
    if missing:
        narrative_batch_score -= len(missing) * 3
    if categories:
        counts = {category: categories.count(category) for category in unique}
        max_share = max(counts.values()) / len(categories)
        if max_share > 0.35:
            narrative_batch_score -= (max_share - 0.35) * 40
    return clamp(narrative_batch_score)


def parse_args():
    parser = argparse.ArgumentParser(description="Compute Elena Voss consistency score and ISI.")
    parser.add_argument("--reference-metadata", default="dataset_lora/metadata.json")
    parser.add_argument("--target-metadata", default="dataset_lora/metadata.json")
    parser.add_argument("--identity-bible", default="identity_bible.json")
    parser.add_argument("--batch-name", default="elena_lora_dataset_bootstrap")
    parser.add_argument("--lora-path", default=DEFAULT_LORA)
    parser.add_argument("--result-json", default="docs/consistency-score-latest.json")
    parser.add_argument("--sql-file", default="database/consistency-score-latest.sql")
    parser.add_argument("--env-file", default="database/.env.postgres.local")
    parser.add_argument("--psql", default=r"C:\Program Files\PostgreSQL\17\bin\psql.exe")
    parser.add_argument("--min-reference-faces", type=int, default=10)
    parser.add_argument("--min-reference-bodies", type=int, default=10)
    parser.add_argument("--skip-db", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    identity_bible = load_json(ROOT / args.identity_bible)
    lora_path = ROOT / args.lora_path
    lora_present = True
    reference_rows = resolve_image_rows(ROOT / args.reference_metadata)
    target_rows = resolve_image_rows(ROOT / args.target_metadata)
    if len(reference_rows) < args.min_reference_faces:
        raise RuntimeError("Reference set too small for consistency scoring")
    if not target_rows:
        raise RuntimeError("No target images found for consistency scoring")

    mtcnn = MTCNN(image_size=160, margin=20, keep_all=False, device="cpu")
    resnet = InceptionResnetV1(pretrained="vggface2").eval()
    mp_pose = mp.solutions.pose

    reference_faces = []
    reference_bodies = []
    reference_styles = []
    with mp_pose.Pose(static_image_mode=True, model_complexity=1, enable_segmentation=False) as pose_model:
        for row in reference_rows:
            image = image_rgb(row["image_path"])
            face = face_embedding(image, mtcnn, resnet)
            if face is not None:
                reference_faces.append(face)
            body, _ = body_vector(image, pose_model)
            if body is not None:
                reference_bodies.append(body)
            reference_styles.append(style_vector(image))

        face_centroid = compute_centroid(reference_faces)
        body_centroid = compute_centroid(reference_bodies)
        style_centroid = compute_centroid(reference_styles)
        if face_centroid is None or len(reference_faces) < args.min_reference_faces:
            raise RuntimeError("Not enough reference face embeddings")
        if body_centroid is None or len(reference_bodies) < args.min_reference_bodies:
            raise RuntimeError("Not enough reference body pose vectors")
        if style_centroid is None:
            raise RuntimeError("Not enough reference style vectors")

        item_results = []
        for row in target_rows:
            image = image_rgb(row["image_path"])
            face = face_embedding(image, mtcnn, resnet)
            body, body_metrics = body_vector(image, pose_model)
            style = style_vector(image)
            narrative, narrative_metrics = narrative_score(row)

            if face is None:
                face_score = 0.0
                face_metrics = {"face_detected": False, "face_similarity": 0.0}
            else:
                similarity = cosine(face, face_centroid)
                face_score = round(score_from_cosine(similarity), 2)
                face_metrics = {"face_detected": True, "face_similarity": round(similarity, 5)}

            if body is None:
                body_score = 0.0
                body_distance = None
            else:
                valid_body_dims = np.isfinite(body) & np.isfinite(body_centroid)
                if int(valid_body_dims.sum()) < 4:
                    body_score = 0.0
                    body_distance = None
                else:
                    body_distance = float(np.linalg.norm(body[valid_body_dims] - body_centroid[valid_body_dims]))
                    completeness = float(body_metrics.get("body_completeness", 0.0))
                    body_score = round(score_from_distance(body_distance, 2.2) * (0.75 + 0.25 * completeness), 2)
                completeness = float(body_metrics.get("body_completeness", 0.0))

            style_distance = float(np.linalg.norm(style - style_centroid))
            style_score = round(score_from_distance(style_distance, STYLE_DISTANCE_SCALE), 2)
            global_score = weighted_global(face_score, body_score, style_score, narrative)
            approved = (
                face_score >= QUALITY_TARGETS["face"]
                and body_score >= QUALITY_TARGETS["body"]
                and style_score >= QUALITY_TARGETS["style"]
                and narrative >= QUALITY_TARGETS["narrative"]
                and global_score >= QUALITY_TARGETS["global"]

            )
            item_results.append(
                {
                    "image_path": row["relative_path"],
                    "category": row["category"],
                    "scores": {
                        "face": face_score,
                        "body": body_score,
                        "style": style_score,
                        "narrative": round(narrative, 2),
                        "global": global_score,
                    },
                    "approved": approved,
                    "metrics": {
                        **face_metrics,
                        **body_metrics,
                        "body_distance": round(body_distance, 5) if body_distance is not None else None,
                        "style_distance": round(style_distance, 5),
                        "narrative": narrative_metrics,
                    },
                }
            )

    face_batch = mean([item["scores"]["face"] for item in item_results])
    body_batch = mean([item["scores"]["body"] for item in item_results])
    style_batch = mean([item["scores"]["style"] for item in item_results])
    narrative_batch = apply_distribution_penalty(target_rows, mean([item["scores"]["narrative"] for item in item_results]))
    global_batch = weighted_global(face_batch, body_batch, style_batch, narrative_batch)
    isi = weighted_isi(face_batch, body_batch, narrative_batch)

    rejection_reasons = []

    if face_batch < QUALITY_TARGETS["face"]:
        rejection_reasons.append("face_consistency_below_90")
    if body_batch < QUALITY_TARGETS["body"]:
        rejection_reasons.append("body_consistency_below_90")
    if style_batch < QUALITY_TARGETS["style"]:
        rejection_reasons.append("style_consistency_below_85")
    if narrative_batch < QUALITY_TARGETS["narrative"]:
        rejection_reasons.append("narrative_consistency_below_85")
    if global_batch < QUALITY_TARGETS["global"]:
        rejection_reasons.append("global_consistency_below_90")
    if isi < QUALITY_TARGETS["isi"]:
        rejection_reasons.append("isi_below_90")

    gate_status = "approved" if not rejection_reasons else "rejected"
    approved = gate_status == "approved"
    result = {
        "batch_id": str(uuid.uuid4()),
        "created_at": datetime.now(timezone.utc).isoformat(),
        "character_slug": CHARACTER_SLUG,
        "batch_name": args.batch_name,
        "identity_bible": args.identity_bible,
        "source_metadata": args.target_metadata,
        "reference_metadata": args.reference_metadata,
        "lora_path": args.lora_path,
        "lora_present": lora_present,
        "scores": {
            "face": face_batch,
            "body": body_batch,
            "style": style_batch,
            "narrative": narrative_batch,
            "global": global_batch,
            "isi": isi,
        },
        "targets": QUALITY_TARGETS,
        "approved": approved,
        "gate_status": gate_status,
        "rejection_reasons": rejection_reasons,
        "metrics": {
            "reference_faces": len(reference_faces),
            "reference_bodies": len(reference_bodies),
            "reference_styles": len(reference_styles),
            "target_images": len(target_rows),
            "identity_stability_goal": identity_bible["quality_targets"]["consecutive_approved_images_goal"],
        },
        "items": item_results,
    }
    result_path = ROOT / args.result_json
    result_path.parent.mkdir(parents=True, exist_ok=True)
    result_path.write_text(json.dumps(result, indent=2, ensure_ascii=True), encoding="utf-8")

    sql_path = ROOT / args.sql_file
    write_sql(sql_path, result)
    psql_returncode = None
    if not args.skip_db:
        env_values = parse_env(ROOT / args.env_file)
        psql_result = run_psql(Path(args.psql), env_values, sql_path)
        psql_returncode = psql_result.returncode
        if psql_result.returncode != 0:
            print(psql_result.stdout, flush=True)
            print(psql_result.stderr, flush=True)
            raise RuntimeError(f"psql failed with exit code {psql_result.returncode}")
    print(
        json.dumps(
            {
                "status": gate_status,
                "approved": approved,
                "scores": result["scores"],
                "rejection_reasons": rejection_reasons,
                "result_json": args.result_json,
                "psql_returncode": psql_returncode,
            },
            indent=2,
            ensure_ascii=True,
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
