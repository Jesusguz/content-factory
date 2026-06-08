import argparse
import json
import math
import shutil
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path

import cv2
import mediapipe as mp
import numpy as np
import torch
from facenet_pytorch import InceptionResnetV1, MTCNN
from PIL import Image

# Re-use consistency logic from scripts/consistency_score.py
import consistency_score

ROOT = Path(__file__).resolve().parents[1]

def process_candidate(candidate_name, metadata_path, mtcnn, resnet, pose_model):
    print(f"\n--- SCORING {candidate_name} ---")
    rows = consistency_score.resolve_image_rows(ROOT / metadata_path)
    if len(rows) < 50:
        print(f"WARNING: {candidate_name} has {len(rows)} images, expected 50.")

    faces = []
    bodies = []
    styles = []
    item_results = []

    # First pass: Extract embeddings to find centroids
    for row in rows:
        image = consistency_score.image_rgb(ROOT / row["image_path"])
        face = consistency_score.face_embedding(image, mtcnn, resnet)
        if face is not None:
            faces.append(face)
        body, _ = consistency_score.body_vector(image, pose_model)
        if body is not None:
            bodies.append(body)
        styles.append(consistency_score.style_vector(image))

    face_centroid = consistency_score.compute_centroid(faces)
    body_centroid = consistency_score.compute_centroid(bodies)
    style_centroid = consistency_score.compute_centroid(styles)

    if face_centroid is None or len(faces) < 10:
        return {"face": 0, "body": 0, "style": 0, "narrative": 0, "global": 0, "isi": 0}

    # Second pass: compute scores
    for row in rows:
        image = consistency_score.image_rgb(ROOT / row["image_path"])
        face = consistency_score.face_embedding(image, mtcnn, resnet)
        body, body_metrics = consistency_score.body_vector(image, pose_model)
        style = consistency_score.style_vector(image)
        narrative, _ = consistency_score.narrative_score(row)

        if face is None:
            face_score = 0.0
        else:
            similarity = consistency_score.cosine(face, face_centroid)
            face_score = round(consistency_score.score_from_cosine(similarity), 2)

        if body is None:
            body_score = 0.0
        else:
            valid_body_dims = np.isfinite(body) & np.isfinite(body_centroid)
            if int(valid_body_dims.sum()) < 4:
                body_score = 0.0
            else:
                body_distance = float(np.linalg.norm(body[valid_body_dims] - body_centroid[valid_body_dims]))
                completeness = float(body_metrics.get("body_completeness", 0.0))
                body_score = round(consistency_score.score_from_distance(body_distance, 2.2) * (0.75 + 0.25 * completeness), 2)

        style_distance = float(np.linalg.norm(style - style_centroid))
        style_score = round(consistency_score.score_from_distance(style_distance, consistency_score.STYLE_DISTANCE_SCALE), 2)

        item_results.append({
            "face": face_score,
            "body": body_score,
            "style": style_score,
            "narrative": narrative
        })

    face_batch = consistency_score.mean([item["face"] for item in item_results])
    body_batch = consistency_score.mean([item["body"] for item in item_results])
    style_batch = consistency_score.mean([item["style"] for item in item_results])
    narrative_batch = consistency_score.apply_distribution_penalty(rows, consistency_score.mean([item["narrative"] for item in item_results]))
    global_batch = consistency_score.weighted_global(face_batch, body_batch, style_batch, narrative_batch)
    isi = consistency_score.weighted_isi(face_batch, body_batch, narrative_batch)

    scores = {
        "face": face_batch,
        "body": body_batch,
        "style": style_batch,
        "narrative": narrative_batch,
        "global": global_batch,
        "isi": isi
    }
    print(f"Results: Face={face_batch}, Body={body_batch}, ISI={isi}")
    return scores

def main():
    mtcnn = MTCNN(image_size=160, margin=20, keep_all=False, device="cpu")
    resnet = InceptionResnetV1(pretrained="vggface2").eval()
    mp_pose = mp.solutions.pose

    candidates = ["Candidate_A", "Candidate_B", "Candidate_C", "Candidate_D", "Candidate_E"]
    results = {}

    with mp_pose.Pose(static_image_mode=True, model_complexity=1, enable_segmentation=False) as pose_model:
        for candidate in candidates:
            metadata_path = f"output/candidates/{candidate}_metadata.json"
            if not (ROOT / metadata_path).exists():
                print(f"Missing {metadata_path}, skipping.")
                continue

            scores = process_candidate(candidate, metadata_path, mtcnn, resnet, pose_model)
            results[candidate] = scores

    # Find winner
    winner = None
    best_isi = -1

    for candidate, scores in results.items():
        if scores["face"] >= 90 and scores["body"] >= 90 and scores["isi"] >= 90:
            if scores["isi"] > best_isi:
                best_isi = scores["isi"]
                winner = candidate

    if not winner:
        print("\nFAILURE: No candidate met the strict criteria (Face>=90, Body>=90, ISI>=90).")
        # For robustness during generation phase, we might still output the highest ISI one if needed,
        # but rules state: Reject candidate.
        sys.exit(1)

    print(f"\n======================================")
    print(f"WINNING IDENTITY: {winner}")
    print(f"Scores: Face={results[winner]['face']}, Body={results[winner]['body']}, ISI={results[winner]['isi']}")
    print(f"======================================\n")

    # Write canonical markdown
    canonical_dir = ROOT / "ELENA_VOSS_CANONICAL"
    canonical_dir.mkdir(parents=True, exist_ok=True)

    doc = f"""# ELENA VOSS CANONICAL IDENTITY

## Winning Candidate
{winner}

## Validation Metrics (Measured on 50 images)
- Face Score: {results[winner]['face']}
- Body Score: {results[winner]['body']}
- Style Score: {results[winner]['style']}
- Narrative Score: {results[winner]['narrative']}
- Global Consistency: {results[winner]['global']}
- Identity Stability Index (ISI): {results[winner]['isi']}

## Blend Formula
(Documented in scripts/generate_candidates.py)

## Approval Status
Strict rules applied: Face >= 90, Body >= 90, ISI >= 90. Status: APPROVED.
"""
    (canonical_dir / "ELENA_VOSS_CANONICAL.md").write_text(doc)
    shutil.copy2(ROOT / "identity_bible.json", canonical_dir / "identity_bible.json")

    # Export canonical dataset
    lora_v2_dir = ROOT / "dataset_lora_v2"
    if lora_v2_dir.exists():
        shutil.rmtree(lora_v2_dir)
    lora_v2_dir.mkdir()

    src_dir = ROOT / f"output/candidates/{winner}"
    for cat in src_dir.iterdir():
        if cat.is_dir():
            for img in cat.glob("*.png"):
                shutil.copy2(img, lora_v2_dir / img.name)

    print(f"Dataset exported to {lora_v2_dir}. Ready for Phase 7 (LoRA V2 Training).")

if __name__ == "__main__":
    main()
