import argparse
import csv
import json
import math
import shutil
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

import cv2
import mediapipe as mp
import numpy as np
import torch
from facenet_pytorch import InceptionResnetV1, MTCNN
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN_PROMPT_TERMS = [
    "sunglasses",
    "sun hat",
    "side profile",
    "looking back over shoulder",
    "through cafe window reflection",
    "mirror",
    "no mirror face distortion",
]
TRIGGER_TOKEN = "elena_voss"
IDENTITY_CAPTION = (
    "elena_voss woman, 25 year old woman, warm light olive skin, hazel green-brown eyes, "
    "dark chestnut brown medium-long wavy hair, oval face, straight medium-small nose, "
    "soft defined jaw, subtle warm smile, slim athletic natural build, same face, "
    "same body proportions, realistic identity portrait"
)


@dataclass
class Candidate:
    source_path: Path
    source_id: str
    category: str
    prompt: str
    face_probability: float
    face_area_ratio: float
    face_center_distance: float
    pose_visibility: float
    pose_landmarks_visible: int
    blur_score: float
    quality_score: float
    selected: bool
    rejection_reason: str


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def clamp(value, low, high):
    return max(low, min(high, value))


def prompt_has_forbidden_terms(prompt: str) -> str:
    lowered = prompt.lower()
    for term in FORBIDDEN_PROMPT_TERMS:
        if term in lowered:
            return term
    return ""


def laplacian_blur_score(image_bgr) -> float:
    gray = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2GRAY)
    variance = float(cv2.Laplacian(gray, cv2.CV_64F).var())
    return clamp(variance / 180.0, 0.0, 1.0)


def detect_pose(image_rgb, pose_model):
    result = pose_model.process(image_rgb)
    if not result.pose_landmarks:
        return 0.0, 0
    visible = [
        landmark.visibility
        for landmark in result.pose_landmarks.landmark
        if landmark.visibility >= 0.55
    ]
    if not visible:
        return 0.0, 0
    return float(sum(visible) / len(visible)), len(visible)


def detect_face(image: Image.Image, mtcnn: MTCNN):
    boxes, probs = mtcnn.detect(image)
    if boxes is None or probs is None or len(boxes) != 1:
        return None
    box = boxes[0]
    prob = float(probs[0] or 0.0)
    width, height = image.size
    x1, y1, x2, y2 = [float(v) for v in box]
    face_area = max(0.0, x2 - x1) * max(0.0, y2 - y1)
    face_area_ratio = face_area / float(width * height)
    cx = (x1 + x2) / 2.0
    cy = (y1 + y2) / 2.0
    center_distance = math.sqrt(((cx / width) - 0.5) ** 2 + ((cy / height) - 0.42) ** 2)
    return prob, face_area_ratio, center_distance


def evaluate_candidate(row, mtcnn, pose_model) -> Candidate:
    source_path = ROOT / row["image_path"]
    prompt = row.get("prompt_positive", "")
    forbidden = prompt_has_forbidden_terms(prompt)
    if not source_path.exists():
        return Candidate(
            source_path,
            row.get("id", source_path.stem),
            row.get("category", "unknown"),
            prompt,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            False,
            "missing_file",
        )

    image = Image.open(source_path).convert("RGB")
    image_rgb = np.array(image)
    image_bgr = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)

    face = detect_face(image, mtcnn)
    pose_visibility, pose_visible = detect_pose(image_rgb, pose_model)
    blur = laplacian_blur_score(image_bgr)

    if face is None:
        return Candidate(source_path, row["id"], row["category"], prompt, 0, 0, 1, pose_visibility, pose_visible, blur, 0, False, "face_not_single_or_not_detected")

    face_prob, face_area_ratio, face_center_distance = face
    rejection = ""
    if forbidden:
        rejection = f"forbidden_prompt:{forbidden}"
    elif face_prob < 0.95:
        rejection = "face_probability_below_0.95"
    elif face_area_ratio < 0.020:
        rejection = "face_too_small"
    elif face_area_ratio > 0.260:
        rejection = "face_too_close"
    elif face_center_distance > 0.42:
        rejection = "face_off_center_or_extreme_angle"
    elif blur < 0.12:
        rejection = "image_too_soft"

    face_size_score = 1.0 - clamp(abs(face_area_ratio - 0.075) / 0.075, 0.0, 1.0)
    center_score = 1.0 - clamp(face_center_distance / 0.42, 0.0, 1.0)
    pose_score = clamp((pose_visibility * min(pose_visible, 18) / 18.0), 0.0, 1.0)
    quality = (
        face_prob * 0.34
        + face_size_score * 0.20
        + center_score * 0.16
        + pose_score * 0.15
        + blur * 0.15
    ) * 100.0
    return Candidate(
        source_path,
        row["id"],
        row["category"],
        prompt,
        round(face_prob, 4),
        round(face_area_ratio, 5),
        round(face_center_distance, 5),
        round(pose_visibility, 4),
        pose_visible,
        round(blur, 4),
        round(quality, 2),
        rejection == "",
        rejection,
    )


def cosine(a, b):
    denominator = float(np.linalg.norm(a) * np.linalg.norm(b))
    if denominator == 0:
        return 0.0
    return float(np.dot(a, b) / denominator)


def identity_score_from_similarity(similarity):
    return clamp(((similarity - 0.55) / 0.35) * 100.0, 0.0, 100.0)


def face_embedding(image: Image.Image, mtcnn: MTCNN, resnet: InceptionResnetV1):
    face = mtcnn(image)
    if face is None:
        return None
    with torch.no_grad():
        embedding = resnet(face.unsqueeze(0)).squeeze(0).cpu().numpy()
    return embedding


def build_identity_cluster_scores(candidates, mtcnn, resnet):
    embeddings = []
    for candidate in candidates:
        if not candidate.selected:
            continue
        image = Image.open(candidate.source_path).convert("RGB")
        embedding = face_embedding(image, mtcnn, resnet)
        if embedding is None:
            continue
        embeddings.append((candidate.source_path, embedding))

    scores = {}
    if len(embeddings) < 2:
        return scores

    for path, embedding in embeddings:
        similarities = [
            cosine(embedding, other)
            for other_path, other in embeddings
            if other_path != path
        ]
        mean_similarity = float(sum(similarities) / len(similarities)) if similarities else 0.0
        scores[path] = {
            "identity_cluster_similarity": round(mean_similarity, 5),
            "identity_cluster_score": round(identity_score_from_similarity(mean_similarity), 2),
        }
    return scores


def candidate_to_row(candidate: Candidate, output_path: Path | None = None, identity_scores=None):
    row = {
        "source_id": candidate.source_id,
        "source_path": candidate.source_path.relative_to(ROOT).as_posix(),
        "output_path": output_path.relative_to(ROOT).as_posix() if output_path else "",
        "category": candidate.category,
        "face_probability": candidate.face_probability,
        "face_area_ratio": candidate.face_area_ratio,
        "face_center_distance": candidate.face_center_distance,
        "pose_visibility": candidate.pose_visibility,
        "pose_landmarks_visible": candidate.pose_landmarks_visible,
        "blur_score": candidate.blur_score,
        "quality_score": candidate.quality_score,
        "selected": candidate.selected,
        "rejection_reason": candidate.rejection_reason,
    }
    if identity_scores is not None:
        row.update(
            identity_scores.get(
                candidate.source_path,
                {"identity_cluster_similarity": "", "identity_cluster_score": ""},
            )
        )
    return row


def write_csv(path: Path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        path.write_text("", encoding="utf-8")
        return
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def select_balanced(candidates, target_count, identity_scores=None):
    accepted = [candidate for candidate in candidates if candidate.selected]
    identity_scores = identity_scores or {}

    def ranking_score(candidate):
        cluster = identity_scores.get(candidate.source_path, {}).get("identity_cluster_score", 0.0)
        return (float(cluster) * 0.65) + (float(candidate.quality_score) * 0.35)

    accepted.sort(key=ranking_score, reverse=True)
    categories = sorted({candidate.category for candidate in accepted})
    selected = []
    per_category_floor = max(1, target_count // max(1, len(categories)))

    for category in categories:
        bucket = [candidate for candidate in accepted if candidate.category == category]
        selected.extend(bucket[:per_category_floor])

    seen = {candidate.source_path for candidate in selected}
    for candidate in accepted:
        if len(selected) >= target_count:
            break
        if candidate.source_path not in seen:
            selected.append(candidate)
            seen.add(candidate.source_path)
    return selected[:target_count]


def parse_args():
    parser = argparse.ArgumentParser(description="Select Elena Voss LoRA dataset from existing generated images.")
    parser.add_argument("--source-metadata", default="docs/dataset-valentina-sol.json")
    parser.add_argument("--output-dir", default="dataset_lora")
    parser.add_argument("--target-count", type=int, default=40)
    parser.add_argument("--min-count", type=int, default=30)
    parser.add_argument("--image-dir-name", default="images")
    return parser.parse_args()


def main():
    args = parse_args()
    if args.target_count < args.min_count or args.target_count > 50:
        raise ValueError("--target-count must be between --min-count and 50")

    source_rows = load_json(ROOT / args.source_metadata)
    output_dir = ROOT / args.output_dir
    image_dir = output_dir / args.image_dir_name
    image_dir.mkdir(parents=True, exist_ok=True)

    mtcnn = MTCNN(keep_all=False, device="cpu")
    embedding_mtcnn = MTCNN(image_size=160, margin=20, keep_all=False, device="cpu")
    resnet = InceptionResnetV1(pretrained="vggface2").eval()
    mp_pose = mp.solutions.pose
    candidates = []
    with mp_pose.Pose(static_image_mode=True, model_complexity=1, enable_segmentation=False) as pose_model:
        for row in source_rows:
            candidates.append(evaluate_candidate(row, mtcnn, pose_model))

    identity_scores = build_identity_cluster_scores(candidates, embedding_mtcnn, resnet)
    selected = select_balanced(candidates, args.target_count, identity_scores)
    if len(selected) < args.min_count:
        raise RuntimeError(f"Only {len(selected)} images passed filters; minimum is {args.min_count}")

    for existing in image_dir.glob("elena_voss_*"):
        if existing.is_file():
            existing.unlink()

    selected_rows = []
    for index, candidate in enumerate(selected, start=1):
        suffix = candidate.source_path.suffix.lower()
        output_image = image_dir / f"elena_voss_{index:03d}{suffix}"
        output_caption = image_dir / f"elena_voss_{index:03d}.txt"
        shutil.copy2(candidate.source_path, output_image)
        output_caption.write_text(IDENTITY_CAPTION + "\n", encoding="utf-8")
        selected_rows.append(candidate_to_row(candidate, output_image, identity_scores))

    rejected_rows = [candidate_to_row(candidate, identity_scores=identity_scores) for candidate in candidates if not candidate.selected]
    all_rows = [candidate_to_row(candidate, identity_scores=identity_scores) for candidate in candidates]
    metadata = {
        "schema_version": "1.0",
        "created_at": datetime.now(timezone.utc).isoformat(),
        "source_metadata": args.source_metadata,
        "output_dir": args.output_dir,
        "trigger_token": TRIGGER_TOKEN,
        "identity_caption": IDENTITY_CAPTION,
        "target_count": args.target_count,
        "min_count": args.min_count,
        "selected_count": len(selected_rows),
        "rejected_count": len(rejected_rows),
        "selection_policy": {
            "face_probability_min": 0.95,
            "face_area_ratio_min": 0.020,
            "face_area_ratio_max": 0.260,
            "forbidden_prompt_terms": FORBIDDEN_PROMPT_TERMS,
            "identity_cluster_weight": 0.65,
            "quality_weight": 0.35,
            "training_focus": "identity only; captions intentionally avoid scenario labels",
        },
        "selected": selected_rows,
        "rejected": rejected_rows,
    }
    (output_dir / "metadata.json").write_text(json.dumps(metadata, indent=2, ensure_ascii=True), encoding="utf-8")
    write_csv(output_dir / "selected.csv", selected_rows)
    write_csv(output_dir / "audit.csv", all_rows)
    (output_dir / "README.md").write_text(
        "\n".join(
            [
                "# Elena Voss LoRA Dataset",
                "",
                "Dataset curado automaticamente desde imagenes existentes.",
                "",
                f"- Imagenes seleccionadas: {len(selected_rows)}",
                f"- Trigger token: `{TRIGGER_TOKEN}`",
                "- Captions enfocadas en identidad, no en escenarios.",
                "- Produccion masiva sigue bloqueada hasta entrenar e integrar `models/loras/elena_voss_v1.safetensors`.",
                "",
            ]
        ),
        encoding="utf-8",
    )
    print(json.dumps({"status": "ok", "selected_count": len(selected_rows), "output_dir": args.output_dir}, indent=2), flush=True)


if __name__ == "__main__":
    main()
