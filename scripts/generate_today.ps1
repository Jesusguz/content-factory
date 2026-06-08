$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$ComfyPython = Join-Path $Root "comfyui\.venv\Scripts\python.exe"
$QualityPython = Join-Path $Root "quality\.venv\Scripts\python.exe"
$StartComfy = Join-Path $Root "scripts\start_comfyui.ps1"
$Generator = Join-Path $Root "scripts\generate_valentina_dataset.py"
$Scorer = Join-Path $Root "scripts\consistency_score.py"
$LoraFile = Join-Path $Root "models\loras\elena_voss_v1.safetensors"
$ResultJson = Join-Path $Root "docs\generate-today-result.json"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$MetadataJson = "docs\daily-elena-images-$Stamp.json"
$MetadataCsv = "docs\daily-elena-images-$Stamp.csv"
$ServerOut = Join-Path $Root "comfyui\generate-today-server-out.log"
$ServerErr = Join-Path $Root "comfyui\generate-today-server-err.log"

function Write-Result {
    param([hashtable]$Payload)
    $Payload.generated_at = (Get-Date).ToUniversalTime().ToString("o")
    $Payload | ConvertTo-Json -Depth 8 | Set-Content -Path $ResultJson -Encoding UTF8
    $Payload | ConvertTo-Json -Depth 8
}

function Get-ChildProcessIds {
    param([int]$ParentId)
    $children = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ParentId }
    foreach ($child in $children) {
        [int]$child.ProcessId
        Get-ChildProcessIds -ParentId ([int]$child.ProcessId)
    }
}



if (-not (Test-Path $ComfyPython)) {
    throw "ComfyUI Python not found: $ComfyPython"
}

if (-not (Test-Path $QualityPython)) {
    throw "Quality Python not found: $QualityPython"
}

$server = Start-Process `
    -FilePath "pwsh.exe" `
    -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $StartComfy) `
    -WindowStyle Hidden `
    -PassThru `
    -RedirectStandardOutput $ServerOut `
    -RedirectStandardError $ServerErr

try {
    $deadline = (Get-Date).AddMinutes(5)
    $ready = $false
    do {
        try {
            Invoke-RestMethod -Uri "http://127.0.0.1:8188/system_stats" -TimeoutSec 5 | Out-Null
            $ready = $true
            break
        } catch {
            Start-Sleep -Seconds 3
        }
    } while ((Get-Date) -lt $deadline)

    if (-not $ready) {
        throw "ComfyUI API did not become ready"
    }

    & $ComfyPython $Generator `
        --character-name "Elena Voss" `
        --character-slug "elena_voss" `
        --count-per-category 1 `
        --limit-total 5 `
        --steps 18 `
        --cfg 4.8 `
        --fixed-seed 310520260777 `
        --positive-prompt "prompts\elena-voss-image-positive.txt" `
        --negative-prompt "prompts\elena-voss-image-negative.txt" `
        --metadata-json $MetadataJson `
        --metadata-csv $MetadataCsv

    if ($LASTEXITCODE -ne 0) {
        throw "Image generation failed with exit code $LASTEXITCODE"
    }

    & $QualityPython $Scorer `
        --reference-metadata "dataset_lora\metadata.json" `
        --target-metadata $MetadataJson `
        --batch-name "daily_elena_$Stamp"

    if ($LASTEXITCODE -ne 0) {
        throw "Consistency scoring failed with exit code $LASTEXITCODE"
    }

    $score = Get-Content (Join-Path $Root "docs\consistency-score-latest.json") -Raw | ConvertFrom-Json

    Write-Result @{
        status = $score.gate_status
        approved = [bool]$score.approved
        generated_images = [int]$score.metrics.target_images
        metadata_json = $MetadataJson
        scores = $score.scores
        rejection_reasons = $score.rejection_reasons
    }
}
finally {
    $targets = @(Get-ChildProcessIds -ParentId $server.Id) + @($server.Id)
    $targets = $targets | Sort-Object -Unique
    foreach ($target in $targets) {
        Stop-Process -Id $target -Force -ErrorAction SilentlyContinue
    }
}
