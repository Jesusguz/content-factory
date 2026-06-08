param(
    [int]$MaxTrainSteps = 800,
    [switch]$Smoke
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Python = Join-Path $Root "training\.venv\Scripts\python.exe"
$SdScripts = Join-Path $Root "training\sd-scripts"
$TrainScript = Join-Path $SdScripts "sdxl_train_network.py"
$DatasetConfig = Join-Path $Root "training\elena_lora_dataset.toml"
$Checkpoint = Join-Path $Root "models\checkpoints\realvisxlV50_v50Bakedvae.safetensors"
$OutputDir = Join-Path $Root "models\loras"
$LogDir = Join-Path $Root "training\logs"

if ($Smoke) {
    $MaxTrainSteps = 2
    $OutputName = "elena_voss_v1_smoke"
} else {
    $OutputName = "elena_voss_v1"
}

foreach ($required in @($Python, $TrainScript, $DatasetConfig, $Checkpoint)) {
    if (-not (Test-Path $required)) {
        throw "Required training path missing: $required"
    }
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$env:PYTHONUTF8 = "1"
$env:PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True"
$env:HF_HUB_DISABLE_SYMLINKS_WARNING = "1"

$arguments = @(
    $TrainScript,
    "--pretrained_model_name_or_path", $Checkpoint,
    "--dataset_config", $DatasetConfig,
    "--output_dir", $OutputDir,
    "--output_name", $OutputName,
    "--logging_dir", $LogDir,
    "--save_model_as", "safetensors",
    "--network_module", "networks.lora",
    "--network_dim", "16",
    "--network_alpha", "8",
    "--learning_rate", "1e-4",
    "--unet_lr", "1e-4",
    "--text_encoder_lr", "5e-5",
    "--optimizer_type", "AdamW",
    "--max_train_steps", "$MaxTrainSteps",
    "--mixed_precision", "fp16",
    "--save_precision", "fp16",
    "--cache_latents",
    "--cache_latents_to_disk",
    "--cache_text_encoder_outputs",
    "--cache_text_encoder_outputs_to_disk",
    "--gradient_checkpointing",
    "--network_train_unet_only",
    "--sdpa",
    "--max_data_loader_n_workers", "0",
    "--seed", "260607",
    "--caption_extension", ".txt"
)

if (-not $Smoke) {
    $arguments += @("--save_every_n_steps", "200")
}

Push-Location $SdScripts
try {
    & $Python @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "LoRA training failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

$OutputFile = Join-Path $OutputDir "$OutputName.safetensors"
if (-not (Test-Path $OutputFile)) {
    throw "Expected LoRA output was not created: $OutputFile"
}

Get-Item $OutputFile | Select-Object FullName,Length,LastWriteTime
