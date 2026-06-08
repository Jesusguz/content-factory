$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Python = Join-Path $env:LOCALAPPDATA "Programs\Python\Python311\python.exe"
$Script = Join-Path $Root "scripts\create_short_video.py"

if (-not (Test-Path $Python)) {
    throw "Python not found: $Python"
}

& $Python $Script
if ($LASTEXITCODE -ne 0) {
    throw "Video generation failed with exit code $LASTEXITCODE"
}
