$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "=========================================="
Write-Host " MASTER EXECUTION: IDENTITY REBUILD       "
Write-Host "=========================================="

Write-Host "`n[1/4] Starting ComfyUI Worker (Background)..."
$ComfyProcess = Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", "& { .\comfyui\.venv\Scripts\activate.ps1; python .\comfyui\ComfyUI\main.py --listen 127.0.0.1 --port 8188 --disable-auto-launch --lowvram --xformers --output-directory .\output\candidates }" -WindowStyle Hidden -PassThru

# Wait for ComfyUI to boot
Start-Sleep -Seconds 15

Write-Host "`n[2/4] Generating 250 Candidates (Phase 3)..."
& .\comfyui\.venv\Scripts\python.exe scripts\generate_candidates.py

Write-Host "`n[3/4] Scoring Candidates & Selecting Winner (Phase 4 & 5)..."
& .\quality\.venv\Scripts\python.exe scripts\score_candidates.py

Write-Host "`n[4/4] Training LoRA v2 (Phase 7)..."
& .\comfyui\.venv\Scripts\python.exe scripts\train_lora_v2.py

Write-Host "`nShutting down ComfyUI..."
Stop-Process -Id $ComfyProcess.Id -Force

Write-Host "`n=========================================="
Write-Host " IDENTITY VALIDATION COMPLETE             "
Write-Host " Winner documented in ELENA_VOSS_CANONICAL"
Write-Host "=========================================="
