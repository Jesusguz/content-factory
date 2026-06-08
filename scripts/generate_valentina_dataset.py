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
ALT_CHECKPOINT = "juggernautXL_ragnarokBy.safetensors"
DEFAULT_REQUIRED_LORA = "elena_voss_v1.safetensors"

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
        "looking back over shoulder on a wooden pier, sea blue background, soft cinematic light",
        "fresh coconut drink on a beach table, Valentina smiling naturally, shallow depth of field",
        "coastal promenade after sunrise, clean white outfit, palm shadows, editorial realism",
        "sun hat in hand, ocean horizon, calm confident expression, lifestyle photography",
        "soft side profile near rocks and waves, warm olive skin, realistic natural texture",
        "beach cafe terrace with ocean view, iced coffee, morning content creator routine",
        "packing a small beach bag, sunscreen and towel visible, organized lifestyle scene",
        "stretching gently near the shoreline after a walk, relaxed wellness mood",
        "laughing candidly with wind movement, no other people, premium travel photo",
        "sitting on driftwood near soft waves, pastel coastal tones, 35mm candid portrait",
        "golden hour beach portrait with simple cream dress, elegant relaxed pose",
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
        "checking phone analytics with coffee beside her, content creator workflow",
        "laughing softly while looking off camera, blurred cafe shelves, warm bokeh",
        "writing a caption in a notebook, gold pen, organized creative routine",
        "portrait through cafe window reflection, cinematic but realistic, no logo text",
        "sitting near a tiled wall, linen blazer, subtle confident smile",
        "pour-over coffee setup on table, Valentina observing calmly, sensory detail",
        "coffee shop corner with soft green plants, cream knit top, relaxed elegance",
        "morning cafe selfie-style portrait, realistic phone angle, polished but natural",
        "standing outside a cafe doorway, city morning light, minimal signage without readable text",
        "planning weekly content calendar on tablet, coffee and flowers on table",
        "warm cafe portrait with shallow depth of field, approachable lifestyle influencer mood",
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
        "gentle pilates pose, soft lighting, tasteful athletic outfit, no mirror distortion",
        "gym locker area with neutral tones, ponytail variation but same face, minimal accessories",
        "holding headphones, ready for workout, relaxed confident smile",
        "stretching shoulders near large window, sunlit studio, clean background",
        "fitness studio portrait with towel over shoulder, realistic skin texture",
        "checking workout plan on phone, no readable text, organized healthy routine",
        "standing by indoor plants in wellness studio, coral workout top, calm expression",
        "after-cardio candid portrait, slightly dewy skin, still polished and realistic",
        "pre-workout warmup on mat, full body lifestyle frame, balanced composition",
        "holding a small gym bag, clean sneakers, morning fitness routine",
        "cooldown moment with water bottle, soft bokeh, positive balanced energy",
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
        "taxi window portrait, city reflections, cinematic but natural, no brand logos",
        "small breakfast table in a hotel room, coffee and fruit, morning routine",
        "walking with suitcase on cobblestone street, white sneakers, warm golden hour",
        "travel content setup with camera and notebook on table, Valentina reviewing ideas",
        "sunny rooftop terrace, clean outfit, soft skyline bokeh, premium influencer mood",
        "checking itinerary on phone, no readable text, airport window light",
        "standing near a marina during a weekend trip, sea blue palette, gentle smile",
        "minimal hotel hallway portrait, linen outfit, gold earrings, soft confidence",
        "sitting in a train seat by window, dreamy natural light, travel reflection mood",
        "walking near palm-lined street with small suitcase, resort city atmosphere",
        "sunset travel portrait with neutral dress, relaxed elegant pose, shallow depth of field",
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
        "reading on balcony with city plants, linen dress, soft smile, golden hour",
        "healthy breakfast bowl on table, Valentina seated naturally, lifestyle realism",
        "organizing camera gear and phone tripod, virtual influencer production routine",
        "minimal living room portrait, coral accent pillow, clean natural composition",
        "walking through a sunny neighborhood, casual outfit, everyday aspirational mood",
        "writing gratitude notes at desk, candle and notebook, calm sensory detail",
        "preparing a simple salad in bright kitchen, wellness lifestyle content",
        "sitting on floor near bookshelf, relaxed denim outfit, thoughtful expression",
        "checking weekly goals on tablet, no readable text, tidy workspace",
        "holding a bouquet of fresh flowers, soft natural light, approachable smile",
        "golden hour apartment portrait, wavy hair, gold earrings, warm coastal palette",
    ],
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


def load_text(path):
    return Path(path).read_text(encoding="utf-8").strip()


def ensure_checkpoint(base_url, checkpoint):
    info = request_json(base_url, "/object_info/CheckpointLoaderSimple", timeout=90)
    ckpts = info["CheckpointLoaderSimple"]["input"]["required"]["ckpt_name"][0]
    if checkpoint not in ckpts:
        raise RuntimeError(f"Checkpoint not visible to ComfyUI: {checkpoint}")
    return ckpts


def ensure_lora(base_url, lora):
    info = request_json(base_url, "/object_info/LoraLoader", timeout=90)
    loras = info["LoraLoader"]["input"]["required"]["lora_name"][0]
    if lora not in loras:
        raise RuntimeError(f"Required LoRA not visible to ComfyUI: {lora}")
    return loras


def build_workflow(args, positive, negative, seed, filename_prefix):
    model_ref = ["4", 0]
    clip_ref = ["4", 1]
    workflow = {
        "4": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {"ckpt_name": args.checkpoint},
        },
    }
    if args.lora:
        workflow["10"] = {
            "class_type": "LoraLoader",
            "inputs": {
                "model": ["4", 0],
                "clip": ["4", 1],
                "lora_name": args.lora,
                "strength_model": args.lora_strength_model,
                "strength_clip": args.lora_strength_clip,
            },
        }
        model_ref = ["10", 0]
        clip_ref = ["10", 1]
    workflow.update(
        {
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
                "inputs": {"clip": clip_ref, "text": positive},
            },
            "7": {
                "class_type": "CLIPTextEncode",
                "inputs": {"clip": clip_ref, "text": negative},
            },
            "3": {
                "class_type": "KSampler",
                "inputs": {
                    "model": model_ref,
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
    )
    return workflow


def build_workflow_legacy(args, positive, negative, seed, filename_prefix):
    return {
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


def iter_jobs(count_per_category, limit_total):
    produced = 0
    for category, variants in CATEGORIES.items():
        for index, variant in enumerate(variants[:count_per_category], start=1):
            if limit_total is not None and produced >= limit_total:
                return
            yield category, index, variant
            produced += 1


def personalize_variant(text, character_name):
    return (
        text.replace("Valentina Sol", character_name)
        .replace("Valentina", character_name)
    )


def write_metadata(json_path, csv_path, rows):
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(rows, indent=2, ensure_ascii=True), encoding="utf-8")
    fieldnames = [
        "id",
        "character",
        "category",
        "category_index",
        "checkpoint",
        "lora",
        "lora_strength_model",
        "lora_strength_clip",
        "prompt_positive",
        "prompt_negative",
        "seed",
        "steps",
        "cfg",
        "sampler",
        "scheduler",
        "width",
        "height",
        "prompt_id",
        "filename",
        "subfolder",
        "type",
        "image_path",
        "elapsed_seconds",
        "created_at",
        "approved",
        "notes",
    ]
    with csv_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def parse_args():
    parser = argparse.ArgumentParser(description="Generate character SDXL dataset with ComfyUI.")
    parser.add_argument("--base-url", default=BASE_URL)
    parser.add_argument("--checkpoint", default=DEFAULT_CHECKPOINT)
    parser.add_argument("--count-per-category", type=int, default=20)
    parser.add_argument("--limit-total", type=int, default=None)
    parser.add_argument("--width", type=int, default=512)
    parser.add_argument("--height", type=int, default=768)
    parser.add_argument("--steps", type=int, default=6)
    parser.add_argument("--cfg", type=float, default=2.0)
    parser.add_argument("--sampler", default="euler")
    parser.add_argument("--scheduler", default="normal")
    parser.add_argument("--seed-base", type=int, default=310520260000)
    parser.add_argument("--fixed-seed", type=int, default=None)
    parser.add_argument("--character-name", default="Valentina Sol")
    parser.add_argument("--character-slug", default="valentina_sol")
    parser.add_argument("--lora", default=None)
    parser.add_argument("--require-lora", action="store_true")
    parser.add_argument("--lora-strength-model", type=float, default=0.85)
    parser.add_argument("--lora-strength-clip", type=float, default=0.85)
    parser.add_argument("--positive-prompt", default="prompts/valentina-sol-image-positive.txt")
    parser.add_argument("--negative-prompt", default="prompts/valentina-sol-image-negative.txt")
    parser.add_argument("--metadata-json", default="docs/dataset-valentina-sol.json")
    parser.add_argument("--metadata-csv", default="docs/dataset-valentina-sol.csv")
    parser.add_argument("--output-relative-root", default="images/generated")
    parser.add_argument("--timeout-seconds", type=int, default=1800)
    return parser.parse_args()


def main():
    args = parse_args()
    if args.count_per_category < 1 or args.count_per_category > 20:
        raise ValueError("--count-per-category must be between 1 and 20")

    positive_base = load_text(args.positive_prompt)
    negative = load_text(args.negative_prompt)
    checkpoints = ensure_checkpoint(args.base_url, args.checkpoint)
    if args.require_lora and not args.lora:
        args.lora = DEFAULT_REQUIRED_LORA
    if args.require_lora or args.lora:
        loras = ensure_lora(args.base_url, args.lora)
        print(f"LORA_VISIBLE={args.lora}", flush=True)
        print(f"LORA_COUNT={len(loras)}", flush=True)
    print(f"CHECKPOINT_VISIBLE={args.checkpoint}", flush=True)
    print(f"CHECKPOINT_COUNT={len(checkpoints)}", flush=True)

    rows = []
    total_jobs = sum(1 for _ in iter_jobs(args.count_per_category, args.limit_total))
    started_at = datetime.now(timezone.utc).isoformat()
    print(f"DATASET_START={started_at}", flush=True)
    print(f"DATASET_TOTAL={total_jobs}", flush=True)

    for number, (category, index, variant) in enumerate(
        iter_jobs(args.count_per_category, args.limit_total),
        start=1,
    ):
        variant = personalize_variant(variant, args.character_name)
        image_id = f"{args.character_slug}_{category}_{index:03d}"
        seed = args.fixed_seed if args.fixed_seed is not None else args.seed_base + (list(CATEGORIES.keys()).index(category) * 1000) + index
        filename_prefix = f"dataset/{args.character_slug}/{category}/{image_id}"
        positive = (
            f"{positive_base}, {variant}, single person, same identity, "
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
        image_path = str(Path(args.output_relative_root) / subfolder / filename)
        row = {
            "id": image_id,
            "character": args.character_name,
            "category": category,
            "category_index": index,
            "checkpoint": args.checkpoint,
            "lora": args.lora or "",
            "lora_strength_model": args.lora_strength_model if args.lora else "",
            "lora_strength_clip": args.lora_strength_clip if args.lora else "",
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
            "image_path": image_path.replace("\\", "/"),
            "elapsed_seconds": elapsed,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "approved": False,
            "notes": "initial_sdxl_seed_dataset",
        }
        rows.append(row)
        write_metadata(Path(args.metadata_json), Path(args.metadata_csv), rows)
        print(
            f"GENERATED {number}/{total_jobs} {image_id} seed={seed} elapsed={elapsed}s path={row['image_path']}",
            flush=True,
        )

    finished_at = datetime.now(timezone.utc).isoformat()
    print(f"DATASET_FINISHED={finished_at}", flush=True)
    print(f"DATASET_ROWS={len(rows)}", flush=True)
    print(f"METADATA_JSON={args.metadata_json}", flush=True)
    print(f"METADATA_CSV={args.metadata_csv}", flush=True)


if __name__ == "__main__":
    try:
        main()
    except (urllib.error.URLError, RuntimeError, TimeoutError, ValueError) as exc:
        print(json.dumps({"error": repr(exc)}, indent=2, ensure_ascii=True), flush=True)
        sys.exit(1)
