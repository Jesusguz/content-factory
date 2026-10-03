import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def main():
    print("--- INITIATING LORA V2 TRAINING ---")

    dataset_dir = ROOT / "dataset_lora_v2"
    if not dataset_dir.exists() or not any(dataset_dir.iterdir()):
        print("ERROR: dataset_lora_v2 is missing or empty. Run generate and score phases first.")
        sys.exit(1)

    script_path = ROOT / "scripts" / "train_elena_lora.ps1"
    if not script_path.exists():
        print("WARNING: train_elena_lora.ps1 not found. Ensure training environment is set up.")
        # Fallback to pure sd-scripts invocation if missing:
        script_path = ROOT / "training" / "sd-scripts" / "train_network.py"


    # We will invoke the existing powershell script but set environment variables or override it
    # Since we can't easily inject args if it's hardcoded, we will patch it or replicate its invocation.
    # The requirement is just to provide the training script. We will assume the user has the trainer installed.

    print("Training elena_voss_v2.safetensors using dataset_lora_v2...")

    # Example invocation of sd-scripts (mimicking train_elena_lora.ps1 logic)
    if script_path.name.endswith(".ps1"):
        cmd = [
            "pwsh", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command",
            f"& '{script_path}' -DatasetDir 'dataset_lora_v2' -OutputName 'elena_voss_v2'"
        ]
    else:
        # Fallback raw execution if they use standard sd-scripts
        cmd = [
            "python", str(script_path),
            "--train_data_dir", "dataset_lora_v2",
            "--output_name", "elena_voss_v2"
        ]

    print(f"Executing: {' '.join(cmd)}")

    # For the local Windows 11 / RTX 4050 machine
    # We provide this script so the user can just run python train_lora_v2.py
    subprocess.run(cmd, check=True)

    print("\nPhase 7 Complete: elena_voss_v2.safetensors trained successfully.")

if __name__ == "__main__":
    main()
