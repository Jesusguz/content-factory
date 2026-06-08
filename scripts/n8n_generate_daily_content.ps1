$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Python = Join-Path $env:LOCALAPPDATA "Programs\Python\Python311\python.exe"
$Script = Join-Path $Root "scripts\generate_editorial_content.py"

if (-not (Test-Path $Python)) {
    throw "Python not found: $Python"
}

& $Python $Script
if ($LASTEXITCODE -ne 0) {
    throw "Content generation failed with exit code $LASTEXITCODE"
}
