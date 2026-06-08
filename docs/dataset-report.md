# Fase 6 - Dataset Inicial Valentina Sol

Fecha: 2026-05-31

## 1. Objetivo

Generar el dataset inicial de Valentina Sol con 100 imagenes consistentes usando ComfyUI + RealVisXL sobre RTX 4050 6GB VRAM.

Distribucion requerida:

- Playa: 20 imagenes.
- Cafeteria: 20 imagenes.
- Gym: 20 imagenes.
- Viajes: 20 imagenes.
- Lifestyle: 20 imagenes.

## 2. Archivos Creados

- `scripts/generate_valentina_dataset.py`
- `scripts/create_dataset_contact_sheet.py`
- `docs/dataset-valentina-sol.json`
- `docs/dataset-valentina-sol.csv`
- `docs/dataset-generation.log`
- `docs/dataset-generation.err.log`
- `docs/dataset-contact-sheet.jpg`
- `docs/dataset-valentina-sol-smoke.json`
- `docs/dataset-valentina-sol-smoke.csv`
- `images/generated/dataset/valentina_sol/playa/*.png`
- `images/generated/dataset/valentina_sol/cafeteria/*.png`
- `images/generated/dataset/valentina_sol/gym/*.png`
- `images/generated/dataset/valentina_sol/viajes/*.png`
- `images/generated/dataset/valentina_sol/lifestyle/*.png`

## 3. Codigo Generado

### Generador De Dataset

Archivo: `scripts/generate_valentina_dataset.py`

Funciones principales:

- Conecta con ComfyUI por API local en `http://127.0.0.1:8188`.
- Verifica que `realvisxlV50_v50Bakedvae.safetensors` este visible.
- Crea workflows SDXL con `CheckpointLoaderSimple`, `EmptyLatentImage`, `CLIPTextEncode`, `KSampler`, `VAEDecode` y `SaveImage`.
- Genera 20 prompts por categoria.
- Usa seeds deterministicas por categoria.
- Guarda metadata incremental en JSON y CSV despues de cada imagen.
- Registra `prompt_id`, path, seed, checkpoint, pasos, cfg, sampler, scheduler, dimensiones y estado de aprobacion.

Parametros usados:

- Checkpoint: `realvisxlV50_v50Bakedvae.safetensors`
- Width: `512`
- Height: `768`
- Steps: `6`
- CFG: `2.0`
- Sampler: `euler`
- Scheduler: `normal`
- Seed base: `310520260000`

### Hoja De Contacto

Archivo: `scripts/create_dataset_contact_sheet.py`

Funciones principales:

- Lee `docs/dataset-valentina-sol.json`.
- Selecciona 3 muestras por categoria.
- Crea `docs/dataset-contact-sheet.jpg` para QA visual.

## 4. Comandos Ejecutados

Validacion de sintaxis:

```powershell
& "comfyui\.venv\Scripts\python.exe" -c "import ast, pathlib; ast.parse(pathlib.Path('scripts/generate_valentina_dataset.py').read_text(encoding='utf-8')); print('PYTHON_AST_OK')"
```

Arranque ComfyUI:

```powershell
$Root=(Get-Location).Path
$Out=Join-Path $Root 'comfyui\dataset-server-out.log'
$Err=Join-Path $Root 'comfyui\dataset-server-err.log'
$PidFile=Join-Path $Root 'comfyui\dataset-server.pid'
$p=Start-Process -FilePath 'pwsh.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $Root 'scripts\start_comfyui.ps1')) -WindowStyle Hidden -PassThru -RedirectStandardOutput $Out -RedirectStandardError $Err
Set-Content -Path $PidFile -Value $p.Id
```

Validacion API:

```powershell
Invoke-RestMethod -Uri 'http://127.0.0.1:8188/system_stats' -TimeoutSec 5
```

Prueba de 1 imagen:

```powershell
& "comfyui\.venv\Scripts\python.exe" scripts\generate_valentina_dataset.py --limit-total 1 --metadata-json docs\dataset-valentina-sol-smoke.json --metadata-csv docs\dataset-valentina-sol-smoke.csv
```

Lote completo:

```powershell
& "comfyui\.venv\Scripts\python.exe" scripts\generate_valentina_dataset.py --count-per-category 20 --metadata-json docs\dataset-valentina-sol.json --metadata-csv docs\dataset-valentina-sol.csv
```

Validacion metadata:

```powershell
$rows = Get-Content docs\dataset-valentina-sol.json -Raw | ConvertFrom-Json
$rows | Group-Object category | Sort-Object Name
```

Validacion de dimensiones:

```powershell
Add-Type -AssemblyName System.Drawing
$files=Get-ChildItem images\generated\dataset\valentina_sol -Recurse -Filter *.png
foreach($f in $files){
  $img=[System.Drawing.Image]::FromFile($f.FullName)
  $img.Dispose()
}
```

Hoja de contacto:

```powershell
& "comfyui\.venv\Scripts\python.exe" scripts\create_dataset_contact_sheet.py
```

Verificacion VRAM:

```powershell
nvidia-smi --query-gpu=memory.used,memory.free,utilization.gpu --format=csv,noheader,nounits
```

## 5. Resultado Esperado

- Dataset inicial con 100 imagenes.
- 20 imagenes por cada categoria requerida.
- Metadata completa en JSON y CSV.
- Imagenes verticales listas para reutilizar en captions, historias y video corto.
- Hoja de contacto para revision visual rapida.
- VRAM liberada al terminar la fase.

## 6. Validacion

### Conteo De Metadata

Resultado:

```text
ROWS=100
cafeteria=20
gym=20
lifestyle=20
playa=20
viajes=20
FIRST=valentina_sol_playa_001|images/generated/dataset/valentina_sol/playa/valentina_sol_playa_001_00001_.png
LAST=valentina_sol_lifestyle_020|images/generated/dataset/valentina_sol/lifestyle/valentina_sol_lifestyle_020_00001_.png
```

### Conteo De Imagenes En Disco

Resultado:

```text
cafeteria=20
gym=20
lifestyle=20
playa=20
viajes=20
```

### Dimensiones

Resultado:

```text
IMAGE_DIMENSION_CHECK=100
BAD_DIMENSIONS=0
```

### Integridad De Paths

Resultado:

```text
MISSING_FILES=0
ERR_LOG_BYTES=0
```

### Rendimiento

Resultado:

```text
TOTAL_ELAPSED_SUM=840.645
AVG_SECONDS=8.406
MIN_SECONDS=2.036
MAX_SECONDS=10.11
```

El primer tiempo bajo corresponde a cache/modelo ya cargado durante la prueba.

### Tamano En Disco

Resultado:

```text
DATASET_BYTES=56425414
DATASET_MB=53.81
DISK_FREE_GB=76.53
DISK_SIZE_GB=449.47
```

### GPU Al Final

Resultado:

```text
0, 5921, 0
```

Interpretacion:

- VRAM usada: 0 MiB.
- VRAM libre: 5921 MiB.
- GPU util: 0%.

### QA Visual

Archivo:

```text
docs/dataset-contact-sheet.jpg
```

Revision:

- La identidad visual mantiene una familia facial coherente: piel oliva, cabello oscuro, estilo limpio, tono lifestyle premium.
- Existe variacion moderada de peinado, angulo y estructura facial porque aun no se entreno LoRA facial ni se aplico IP-Adapter/FaceID.
- Para dataset inicial sin entrenamiento adicional, queda aprobado.
- Para consistencia facial estricta de produccion, la siguiente decision tecnica sera curar las mejores imagenes y usar referencia facial/LoRA en una fase de endurecimiento visual.

## Errores Y Correcciones

### Error 1 - Python Venv En Sandbox

Sintoma:

```text
Unable to create process using ...
```

Causa:

El sandbox de solo lectura bloqueo la ejecucion normal del Python del venv.

Correccion:

Se ejecuto el mismo comando con permisos elevados y la validacion devolvio:

```text
PYTHON_AST_OK
```

### Error 2 - Variable Reservada `$pid`

Sintoma:

```text
Cannot overwrite variable PID because it is read-only or constant.
```

Causa:

El monitor de progreso uso `$pid`, variable reservada de PowerShell.

Correccion:

Se cambio a `$datasetPid`. El generador nunca fallo; solo fallo el monitor.

### Error 3 - Parada De ComfyUI Sin Salida

Sintoma:

El comando de parada termino con codigo `-1` sin imprimir confirmacion.

Causa:

El filtro de procesos incluia el texto `ComfyUI\main.py` dentro del propio comando, por lo que corto su shell antes de imprimir.

Correccion:

Se verifico estado posterior:

```text
COMFYUI_API=down
GPU=0, 5921, 0
```

## Decision CTO

Fase 6 queda aprobada.

El dataset inicial existe, esta organizado por categoria, tiene metadata utilizable para PostgreSQL y cuenta con evidencia visual de QA. La consistencia facial es suficiente para dataset inicial; la consistencia estricta de produccion se tratara con curacion y referencia facial en el pipeline de imagen.
