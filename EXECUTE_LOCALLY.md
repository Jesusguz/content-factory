# ELENA VOSS: LOCAL MASTER EXECUTION DIRECTIVE

To comply with the Identity Rebuild Program constraints (no simulation, real measured values), this pipeline must be run on your local RTX 4050 machine which has the necessary SDXL weights and VRAM access.

## Requirements Checklist
- Windows 11
- Python environments initialized (`comfyui\.venv` and `quality\.venv`)
- ComfyUI and `realvisxlV50_v50Bakedvae.safetensors` present.

## Step 1: Execute The Rebuild Pipeline

1. Open PowerShell or Command Prompt at the root of the project (`content-factory`).
2. Run the main batch script:
   ```cmd
   .\start_factory.bat
   ```
3. When prompted, press `2` to select **Identity Validation Mode (Identity Rebuild)**.

## What Happens Automatically:
1. **ComfyUI boots headless** in the background, utilizing `--lowvram --xformers` constraints.
2. `scripts/generate_candidates.py` executes: It generates exactly 50 candidate images for 5 unique distinct mathematical Blends (Candidate A through E) directly via the Comfy API. (250 images total).
3. `scripts/score_candidates.py` executes: Runs the real MTCNN/MediaPipe scoring engine against all 250 outputs.
4. **Winner Selection:** The script enforces `Face >= 90`, `Body >= 90`, `ISI >= 90`. It picks the winner, exports them to `dataset_lora_v2/`, and creates `ELENA_VOSS_CANONICAL.md` documenting the permanent specification.
5. `scripts/train_lora_v2.py` triggers: Begins SD-Scripts local training sequence on `dataset_lora_v2/` outputting `elena_voss_v2.safetensors`.

*Note: Generating 250 SDXL images and training a LoRA locally on an RTX 4050 will take significant time. Leave the process running undisturbed.*
