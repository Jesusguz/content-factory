$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Python = Join-Path $Root "comfyui\.venv\Scripts\python.exe"
$ComfyMain = Join-Path $Root "comfyui\ComfyUI\main.py"
$OutputDir = Join-Path $Root "output\images"

if (-not (Test-Path $Python)) {
    throw "ComfyUI venv Python not found: $Python"
}

if (-not (Test-Path $ComfyMain)) {
    throw "ComfyUI main.py not found: $ComfyMain"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

& $Python $ComfyMain `
    --listen 127.0.0.1 `
    --port 8188 `
    --disable-auto-launch `
    --lowvram `
    --output-directory $OutputDir
