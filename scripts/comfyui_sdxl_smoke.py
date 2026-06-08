import json
import sys
import time
import urllib.error
import urllib.request
import uuid


BASE_URL = "http://127.0.0.1:8188"
CHECKPOINT = "realvisxlV50_v50Bakedvae.safetensors"


def request_json(path, payload=None, timeout=30):
    url = BASE_URL + path
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


def assert_checkpoint_visible():
    info = request_json("/object_info/CheckpointLoaderSimple", timeout=60)
    ckpts = info["CheckpointLoaderSimple"]["input"]["required"]["ckpt_name"][0]
    if CHECKPOINT not in ckpts:
        raise RuntimeError(f"Checkpoint not visible to ComfyUI: {CHECKPOINT}")
    return ckpts


def build_prompt():
    return {
        "4": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {"ckpt_name": CHECKPOINT},
        },
        "5": {
            "class_type": "EmptyLatentImage",
            "inputs": {"width": 512, "height": 512, "batch_size": 1},
        },
        "6": {
            "class_type": "CLIPTextEncode",
            "inputs": {
                "clip": ["4", 1],
                "text": (
                    "professional lifestyle portrait photo of Valentina Sol, "
                    "virtual latina influencer, sunlit cafe, natural skin, "
                    "consistent face, warm cinematic light"
                ),
            },
        },
        "7": {
            "class_type": "CLIPTextEncode",
            "inputs": {
                "clip": ["4", 1],
                "text": (
                    "low quality, blurry, distorted face, extra fingers, text, "
                    "watermark, logo, deformed, duplicate person"
                ),
            },
        },
        "3": {
            "class_type": "KSampler",
            "inputs": {
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0],
                "seed": 31052026,
                "steps": 4,
                "cfg": 1.5,
                "sampler_name": "euler",
                "scheduler": "normal",
                "denoise": 1.0,
            },
        },
        "8": {
            "class_type": "VAEDecode",
            "inputs": {"samples": ["3", 0], "vae": ["4", 2]},
        },
        "9": {
            "class_type": "SaveImage",
            "inputs": {"filename_prefix": "comfyui_sdxl_smoke", "images": ["8", 0]},
        },
    }


def queue_prompt():
    payload = {"client_id": str(uuid.uuid4()), "prompt": build_prompt()}
    return request_json("/prompt", payload=payload, timeout=60)


def poll_history(prompt_id, timeout_seconds=900):
    deadline = time.time() + timeout_seconds
    while time.time() < deadline:
        history = request_json(f"/history/{prompt_id}", timeout=30)
        if prompt_id in history:
            item = history[prompt_id]
            status = item.get("status", {})
            if status.get("completed"):
                return item
            messages = status.get("messages", [])
            if any("execution_error" in str(message) for message in messages):
                raise RuntimeError(json.dumps(status, ensure_ascii=True))
        time.sleep(2)
    raise TimeoutError(f"Timed out waiting for ComfyUI prompt {prompt_id}")


def main():
    start = time.perf_counter()
    checkpoints = assert_checkpoint_visible()
    queued = queue_prompt()
    prompt_id = queued["prompt_id"]
    history = poll_history(prompt_id)
    elapsed = time.perf_counter() - start
    outputs = []
    for node in history.get("outputs", {}).values():
        for image in node.get("images", []):
            outputs.append(image)
    result = {
        "checkpoint": CHECKPOINT,
        "checkpoint_count": len(checkpoints),
        "prompt_id": prompt_id,
        "elapsed_seconds": round(elapsed, 3),
        "outputs": outputs,
        "status": history.get("status", {}),
    }
    print(json.dumps(result, indent=2, ensure_ascii=True))


if __name__ == "__main__":
    try:
        main()
    except (urllib.error.URLError, RuntimeError, TimeoutError) as exc:
        print(json.dumps({"error": repr(exc)}, indent=2, ensure_ascii=True))
        sys.exit(1)
