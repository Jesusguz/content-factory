$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$GenerateToday = Join-Path $Root "scripts\generate_today.ps1"

if (-not (Test-Path $GenerateToday)) {
    throw "Generate today script not found: $GenerateToday"
}

& pwsh -NoProfile -ExecutionPolicy Bypass -File $GenerateToday

if ($LASTEXITCODE -ne 0) {
    throw "Generate today failed with exit code $LASTEXITCODE"
}
