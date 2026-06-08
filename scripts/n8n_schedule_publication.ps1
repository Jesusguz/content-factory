$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$EnvFile = Join-Path $Root "database\.env.postgres.local"
$Psql = "C:\Program Files\PostgreSQL\17\bin\psql.exe"
$ScoreFile = Join-Path $Root "docs\consistency-score-latest.json"
$ResultFile = Join-Path $Root "docs\schedule-publication-result.json"

function Write-Result {
    param([hashtable]$Payload)
    $Payload.generated_at = (Get-Date).ToUniversalTime().ToString("o")
    $Payload | ConvertTo-Json -Depth 8 | Set-Content -Path $ResultFile -Encoding UTF8
    $Payload | ConvertTo-Json -Depth 8
}

if (-not (Test-Path $EnvFile)) {
    throw "Postgres env file not found: $EnvFile"
}

if (-not (Test-Path $ScoreFile)) {
    Write-Result @{
        status = "blocked_missing_consistency_score"
        approved = $false
        scheduled = $false
        reason = "docs/consistency-score-latest.json does not exist"
    }
    exit 0
}

$score = Get-Content $ScoreFile -Raw | ConvertFrom-Json
if (-not [bool]$score.approved) {
    Write-Result @{
        status = "blocked_consistency_gate"
        approved = $false
        scheduled = $false
        gate_status = $score.gate_status
        scores = $score.scores
        rejection_reasons = $score.rejection_reasons
    }
    exit 0
}

$envMap = @{}
Get-Content $EnvFile | Where-Object { $_ -match "=" } | ForEach-Object {
    $key, $value = $_.Split("=", 2)
    $envMap[$key] = $value
}

$env:PGPASSWORD = $envMap["POSTGRES_PASSWORD"]

$Sql = @"
INSERT INTO publication_queue (
    content_item_id,
    character_slug,
    platform,
    media_path,
    caption,
    scheduled_for,
    status,
    metadata
)
SELECT
    id,
    'elena-voss',
    'TikTok',
    'videos/generated/elena_voss_lifestyle_short.mp4',
    body,
    now() + interval '1 day',
    'scheduled',
    jsonb_build_object(
        'source', 'n8n_schedule_publication',
        'content_type', content_type,
        'category', category
    )
FROM content_items
WHERE character_slug = 'elena-voss'
  AND content_type = 'caption'
ORDER BY created_at DESC
LIMIT 1
RETURNING id, scheduled_for, platform, media_path;
"@

& $Psql `
    -h $envMap["POSTGRES_HOST"] `
    -p $envMap["POSTGRES_PORT"] `
    -U $envMap["POSTGRES_USER"] `
    -d $envMap["POSTGRES_DB"] `
    -v ON_ERROR_STOP=1 `
    -c $Sql

if ($LASTEXITCODE -ne 0) {
    throw "Publication scheduling failed with exit code $LASTEXITCODE"
}

Write-Result @{
    status = "scheduled"
    approved = $true
    scheduled = $true
    gate_status = $score.gate_status
    scores = $score.scores
}
