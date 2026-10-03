import argparse
import csv
import json
import sys
import time
import urllib.error
import urllib.request
import uuid
from datetime import datetime, timezone
from pathlib import Path

BASE_URL = "http://127.0.0.1:8188"
DEFAULT_CHECKPOINT = "realvisxlV50_v50Bakedvae.safetensors"

# Generate exactly 50 jobs per candidate, 10 per category
CATEGORIES = {
    "playa": [
        "walking on a quiet beach at sunrise, cream linen shirt, sea breeze, soft waves in background",
        "sitting on a woven beach towel with a straw tote, golden hour, natural candid smile",
        "standing near turquoise water, light denim shorts, relaxed editorial summer pose",
        "holding sunglasses near the shore, wet sand reflection, clean coastal palette",
        "reading a small book under a white beach umbrella, calm premium lifestyle mood",
        "close portrait with ocean bokeh, minimal gold earrings, wind in wavy hair",
        "walking barefoot on sand with linen overshirt, warm sun, travel diary mood",
        "holding a reusable water bottle after a morning beach walk, healthy lifestyle aesthetic",
        "seated on a low beach chair, coral swimsuit covered by linen wrap, tasteful non-revealing styling",
        "looking back over shoulder on a wooden pier, sea blue background, soft cinematic light"
    ],
    "cafeteria": [
        "standing outside a bright cafe doorway, full body visible, white blouse, light denim, iced latte in hand, morning planning routine",
        "standing at a minimalist coffee bar, white blouse, warm wood interior",
        "reading notes in a small notebook beside cappuccino, cozy urban lifestyle",
        "window seat portrait with soft daylight, plants behind her, calm smile",
        "holding a ceramic mug with both hands, natural makeup, intimate editorial photo",
        "typing content ideas on a laptop in a bright cafe, focused but friendly mood",
        "flat white and croissant on table, Valentina leaning slightly forward, candid realism",
        "ordering coffee at a modern cafe counter, clean neutral outfit, premium everyday style",
        "small balcony cafe with morning light, coral scarf accent, travel city feel",
        "checking phone analytics with coffee beside her, content creator workflow"
    ],
    "gym": [
        "bright boutique gym, full body visible, clean athleisure, holding towel and water bottle after workout",
        "mirror-free gym portrait, olive leggings and white top, healthy confident pose",
        "stretching on a mat in soft morning light, realistic wellness lifestyle",
        "tying sneakers before a workout, close lifestyle detail, natural face visible",
        "standing near dumbbell rack, no heavy lifting, calm focused expression",
        "post-workout smoothie in hand, minimal gym lounge, fresh natural makeup",
        "using resistance band in a clean studio, elegant athletic posture",
        "walking on treadmill area, side portrait, premium fitness content aesthetic",
        "seated on yoga mat with notebook and bottle, wellness routine planning",
        "gentle pilates pose, soft lighting, tasteful athletic outfit, no mirror distortion"
    ],
    "viajes": [
        "walking through an airport lounge with small suitcase, full body visible, cream trench, calm travel morning mood",
        "standing on a sunny colonial street, light denim and linen, travel diary aesthetic",
        "hotel balcony breakfast, city view, soft morning light, premium lifestyle photo",
        "train station platform with carry-on suitcase, elegant travel outfit, no readable signs",
        "walking through a boutique hotel lobby, warm lighting, relaxed confident pose",
        "packing a suitcase on a bed, organized travel essentials, natural candid smile",
        "looking at a city map without readable text, sunglasses, weekend escape mood",
        "scenic overlook with sea and city background, wind in hair, editorial travel portrait",
        "boutique market street, woven bag, soft colorful background, realistic candid",
        "taxi window portrait, city reflections, cinematic but natural, no brand logos"
    ],
    "lifestyle": [
        "walking through a bright apartment kitchen, full body visible, making matcha on a clean counter, calm morning routine",
        "sitting on a sofa with laptop and notebook, planning content calendar, soft daylight",
        "watering indoor plants, cream outfit, warm olive skin, calm home lifestyle",
        "getting ready at vanity with natural makeup, no mirror face distortion, elegant detail",
        "choosing outfits from a neutral capsule wardrobe, organized aesthetic",
        "standing by a sunny window with coffee, quiet reflective morning mood",
        "flatlay desk scene with Valentina writing ideas, face visible, premium creator routine",
        "home office portrait, laptop and small flowers, focused friendly expression",
        "evening skincare routine in soft bathroom light, tasteful and non-commercial",
        "reading on balcony with city plants, linen dress, soft smile, golden hour"
    ]
}

CANDIDATES = {
    "Candidate_A": "(face of Ana de Armas:0.6) blended with (face of Barbara Palvin:0.4), symmetrical facial features, highly detailed portrait,",
    "Candidate_B": "(face of Eiza Gonzalez:0.5) blended with (face of Kendall Jenner:0.5), symmetrical facial features, highly detailed portrait,",
    "Candidate_C": "(face of Monica Bellucci:0.4) blended with (face of Gal Gadot:0.6), symmetrical facial features, highly detailed portrait,",
    "Candidate_D": "(face of Penelope Cruz:0.5) blended with (face of Taylor Hill:0.5), symmetrical facial features, highly detailed portrait,",
    "Candidate_E": "(face of Blanca Suarez:0.6) blended with (face of Ana de Armas:0.4), symmetrical facial features, highly detailed portrait,"
}

def request_json(base_url, path, payload=None, timeout=60):
    url = base_url.rstrip("/") + path
    if payload is None:
        with urllib.request.urlopen(url, timeout=timeout) as response:
            return json.loads(response.read().decode("utf-8"))
    data = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))

def build_workflow(args, positive, negative, seed, filename_prefix):
    workflow = {
        "4": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {"ckpt_name": args.checkpoint},
        },
        "5": {
            "class_type": "EmptyLatentImage",
            "inputs": {
                "width": args.width,
                "height": args.height,
                "batch_size": 1,
            },
        },
        "6": {
            "class_type": "CLIPTextEncode",
            "inputs": {"clip": ["4", 1], "text": positive},
        },
        "7": {
            "class_type": "CLIPTextEncode",
            "inputs": {"clip": ["4", 1], "text": negative},
        },
        "3": {
            "class_type": "KSampler",
            "inputs": {
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0],
                "seed": seed,
                "steps": args.steps,
                "cfg": args.cfg,
                "sampler_name": args.sampler,
                "scheduler": args.scheduler,
                "denoise": 1.0,
            },
        },
        "8": {
            "class_type": "VAEDecode",
            "inputs": {"samples": ["3", 0], "vae": ["4", 2]},
        },
        "9": {
            "class_type": "SaveImage",
            "inputs": {"filename_prefix": filename_prefix, "images": ["8", 0]},
        },
    }
    return workflow

def queue_prompt(base_url, workflow):
    payload = {"client_id": str(uuid.uuid4()), "prompt": workflow}
    return request_json(base_url, "/prompt", payload=payload, timeout=90)

def poll_history(base_url, prompt_id, timeout_seconds):
    deadline = time.time() + timeout_seconds
    while time.time() < deadline:
        history = request_json(base_url, f"/history/{prompt_id}", timeout=60)
        if prompt_id in history:
            item = history[prompt_id]
            status = item.get("status", {})
            if status.get("completed"):
                return item
            if any("execution_error" in str(message) for message in status.get("messages", [])):
                raise RuntimeError(json.dumps(status, ensure_ascii=True))
        time.sleep(2)
    raise TimeoutError(f"Timed out waiting for ComfyUI prompt {prompt_id}")

def write_metadata(json_path, csv_path, rows):
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(rows, indent=2, ensure_ascii=True), encoding="utf-8")
    fieldnames = [
        "id", "candidate", "character", "category", "category_index", "checkpoint",
        "prompt_positive", "prompt_negative", "seed", "steps", "cfg", "sampler",
        "scheduler", "width", "height", "prompt_id", "filename", "subfolder",
        "type", "image_path", "elapsed_seconds", "created_at"
    ]
    with csv_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})

def parse_args():
    parser = argparse.ArgumentParser(description="Generate 5 identity candidates (50 images each) using SDXL.")
    parser.add_argument("--base-url", default=BASE_URL)
    parser.add_argument("--checkpoint", default=DEFAULT_CHECKPOINT)
    parser.add_argument("--width", type=int, default=512)
    parser.add_argument("--height", type=int, default=768)
    parser.add_argument("--steps", type=int, default=20)
    parser.add_argument("--cfg", type=float, default=5.0)
    parser.add_argument("--sampler", default="euler")
    parser.add_argument("--scheduler", default="normal")
    parser.add_argument("--seed-base", type=int, default=310520260000)
    parser.add_argument("--positive-prompt", default="prompts/elena-voss-image-positive.txt")
    parser.add_argument("--negative-prompt", default="prompts/elena-voss-image-negative.txt")
    parser.add_argument("--output-dir", default="output/candidates")
    parser.add_argument("--timeout-seconds", type=int, default=1800)
    return parser.parse_args()

def main():
    args = parse_args()
    positive_base = Path(args.positive_prompt).read_text(encoding="utf-8").strip()
    negative = Path(args.negative_prompt).read_text(encoding="utf-8").strip()
    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    print(f"CHECKPOINT_VISIBLE={args.checkpoint}", flush=True)

    for candidate_name, blend_formula in CANDIDATES.items():
        print(f"\n--- GENERATING {candidate_name.upper()} ---")
        rows = []
        metadata_json = out_dir / f"{candidate_name}_metadata.json"
        metadata_csv = out_dir / f"{candidate_name}_metadata.csv"

        number = 1
        for category, variants in CATEGORIES.items():
            for index, variant in enumerate(variants, start=1):
                image_id = f"{candidate_name}_{category}_{index:03d}"
                seed = args.seed_base + list(CATEGORIES.keys()).index(category) * 1000 + index
                filename_prefix = f"{candidate_name}/{category}/{image_id}"

                positive = (
                    f"{blend_formula} {positive_base}, {variant}, single person, same identity, "
                    "consistent facial features, realistic hands when visible, no text, no watermark"
                )

                workflow = build_workflow(args, positive, negative, seed, filename_prefix)
                start = time.perf_counter()
                queued = queue_prompt(args.base_url, workflow)
                prompt_id = queued["prompt_id"]
                history = poll_history(args.base_url, prompt_id, args.timeout_seconds)
                elapsed = round(time.perf_counter() - start, 3)

                output_images = []
                for node in history.get("outputs", {}).values():
                    output_images.extend(node.get("images", []))
                if not output_images:
                    raise RuntimeError(f"No image returned for {image_id}")

                image = output_images[0]
                subfolder = image.get("subfolder", "")
                filename = image.get("filename", "")
                image_path = str(out_dir / candidate_name / category / filename)

                row = {
                    "id": image_id,
                    "candidate": candidate_name,
                    "character": "Elena Voss",
                    "category": category,
                    "category_index": index,
                    "checkpoint": args.checkpoint,
                    "prompt_positive": positive,
                    "prompt_negative": negative,
                    "seed": seed,
                    "steps": args.steps,
                    "cfg": args.cfg,
                    "sampler": args.sampler,
                    "scheduler": args.scheduler,
                    "width": args.width,
                    "height": args.height,
                    "prompt_id": prompt_id,
                    "filename": filename,
                    "subfolder": subfolder,
                    "type": image.get("type", "output"),
                    "image_path": f"output/candidates/{candidate_name}/{category}/{filename}".replace("\\", "/"),
                    "elapsed_seconds": elapsed,
                    "created_at": datetime.now(timezone.utc).isoformat()
                }
                rows.append(row)
                write_metadata(metadata_json, metadata_csv, rows)
                print(f"GENERATED {number}/50 {image_id} seed={seed} elapsed={elapsed}s", flush=True)
                number += 1

if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"Error: {exc}", flush=True)
        sys.exit(1)
