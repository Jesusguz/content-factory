# Fase 4 - ComfyUI Report

Fecha de ejecucion: 2026-05-31 America/Mexico_City
Workspace: `C:\Users\magdi\Documents\Codex\2026-05-31\goal-construir-una-f-brica-de\content-factory`

## 1. Objetivo

Instalar y verificar ComfyUI para generacion local de imagenes SDXL en Windows 11 usando:

- GPU: RTX 4050 Laptop 6 GB VRAM
- CUDA por driver: 12.8
- Python aislado en venv
- PyTorch CUDA
- Checkpoints:
  - RealVisXL
  - JuggernautXL
- Directorios del proyecto para modelos y outputs

## 2. Archivos creados

- `content-factory/comfyui/ComfyUI`
- `content-factory/comfyui/.venv`
- `content-factory/comfyui/ComfyUI/extra_model_paths.yaml`
- `content-factory/comfyui/extra_model_paths.yaml`
- `content-factory/scripts/start_comfyui.ps1`
- `content-factory/scripts/comfyui_sdxl_smoke.py`
- `content-factory/docs/comfyui-smoke-result.json`
- `content-factory/docs/comfyui-report.md`

Modelos descargados:

- `content-factory/models/checkpoints/realvisxlV50_v50Bakedvae.safetensors`
- `content-factory/models/checkpoints/juggernautXL_ragnarokBy.safetensors`

Imagen de validacion generada:

- `content-factory/images/generated/comfyui_sdxl_smoke_00001_.png`

## 3. Codigo generado

### `scripts/start_comfyui.ps1`

Script de arranque operativo:

```powershell
$Root = Split-Path -Parent $PSScriptRoot
$Python = Join-Path $Root "comfyui\.venv\Scripts\python.exe"
$ComfyMain = Join-Path $Root "comfyui\ComfyUI\main.py"
$OutputDir = Join-Path $Root "images\generated"

& $Python $ComfyMain `
    --listen 127.0.0.1 `
    --port 8188 `
    --disable-auto-launch `
    --lowvram `
    --output-directory $OutputDir
```

### `scripts/comfyui_sdxl_smoke.py`

Script de validacion:

- Consulta `/object_info/CheckpointLoaderSimple`.
- Verifica que `realvisxlV50_v50Bakedvae.safetensors` sea visible.
- Encola un workflow SDXL minimo.
- Genera una imagen 512x512 con 4 steps.
- Guarda salida en `images/generated`.

### `extra_model_paths.yaml`

```yaml
content_factory:
  base_path: C:/Users/magdi/Documents/Codex/2026-05-31/goal-construir-una-f-brica-de/content-factory/models
  checkpoints: checkpoints
  loras: loras
  vae: vae
  controlnet: controlnet
```

## 4. Comandos ejecutados

### Clonar ComfyUI

```powershell
git clone https://github.com/comfyanonymous/ComfyUI.git comfyui\ComfyUI
```

Version clonada:

```text
c37d2a0d 2026-05-31T11:47:29-07:00 feat: Add gaussian splat nodes (#14190)
```

### Crear entorno Python

```powershell
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" -m venv comfyui\.venv
& "comfyui\.venv\Scripts\python.exe" -m pip install --upgrade pip setuptools wheel
```

Resultado:

- Python: `3.11.9`
- pip: `26.1.2`

### Instalar PyTorch CUDA

Consulta de indices oficiales:

```powershell
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu128
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu126
```

Decision:

- Se uso `cu128` porque el driver NVIDIA reporta CUDA 12.8 y el indice oficial contiene `torch 2.11.0+cu128`.

Instalacion:

```powershell
& "comfyui\.venv\Scripts\python.exe" -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

Resultado:

- `torch-2.11.0+cu128`
- `torchvision-0.26.0+cu128`
- `torchaudio-2.11.0+cu128`

Validacion CUDA:

```powershell
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"
```

Resultado:

- Torch: `2.11.0+cu128`
- CUDA runtime: `12.8`
- CUDA available: `True`
- Device: `NVIDIA GeForce RTX 4050 Laptop GPU`
- VRAM detectada por PyTorch: `5.997 GiB`

### Instalar requirements ComfyUI

```powershell
& "..\.venv\Scripts\python.exe" -m pip install -r requirements.txt
```

Resultado:

- Requirements instalados correctamente.
- Incidencia menor: pip tuvo un timeout recuperable descargando `comfyui_workflow_templates_media_api`; retomo descarga y finalizo.

### Smoke API ComfyUI

```powershell
python main.py --listen 127.0.0.1 --port 8188 --disable-auto-launch --lowvram
Invoke-RestMethod -Uri http://127.0.0.1:8188/system_stats
```

Resultado:

- ComfyUI: `0.22.0`
- Frontend: `1.44.19`
- Templates: `0.9.91`
- PyTorch: `2.11.0+cu128`
- Device: `cuda:0 NVIDIA GeForce RTX 4050 Laptop GPU : cudaMallocAsync`
- VRAM total: `6140 MB`
- RAM total: `15611 MB`
- VRAM mode: `LOW_VRAM`
- DynamicVRAM: enabled

### Resolver checkpoints por API Civitai

RealVisXL:

```powershell
Invoke-RestMethod https://civitai.com/api/v1/models/139562
Invoke-RestMethod https://civitai.com/api/v1/model-versions/789646
```

Seleccion:

- Modelo: `RealVisXL V5.0`
- Version: `V5.0 (BakedVAE)`
- Base: `SDXL 1.0`
- Version ID: `789646`
- Archivo: `realvisxlV50_v50Bakedvae.safetensors`
- Variante descargada: default SafeTensor ~6.46 GiB, no fp32 ~13.5 GiB

Juggernaut XL:

```powershell
Invoke-RestMethod https://civitai.com/api/v1/models/133005
Invoke-RestMethod https://civitai.com/api/v1/model-versions/1759168
```

Seleccion:

- Modelo: `Juggernaut XL`
- Version: `Ragnarok_by_RunDiffusion`
- Base: `SDXL 1.0`
- Version ID: `1759168`
- Archivo: `juggernautXL_ragnarokBy.safetensors`

### Descargar checkpoints

```powershell
curl.exe --fail --location --retry 20 --retry-all-errors --retry-delay 10 --connect-timeout 60 -C - -A 'content-factory-setup/1.0' -o models\checkpoints\realvisxlV50_v50Bakedvae.safetensors https://civitai.com/api/download/models/789646
curl.exe --silent --show-error --fail --location --retry 20 --retry-all-errors --retry-delay 10 --connect-timeout 60 -C - -A 'content-factory-setup/1.0' -o models\checkpoints\juggernautXL_ragnarokBy.safetensors https://civitai.com/api/download/models/1759168
```

Validacion hashes:

```text
RealVisXL SHA256:
6A35A7855770AE9820A3C931D4964C3817B6D9E3C6F9C4DABB5B3A94E5643B80

Juggernaut XL SHA256:
DD08FA32F98D05A2443CA1419E46DF1575A0811F6E3B246D9DD47FF20F5EB66A
```

Ambos coinciden con la metadata de Civitai.

### Generacion SDXL smoke test

```powershell
python main.py --listen 127.0.0.1 --port 8188 --disable-auto-launch --lowvram --output-directory images\generated
python scripts\comfyui_sdxl_smoke.py
```

Resultado:

```json
{
  "checkpoint": "realvisxlV50_v50Bakedvae.safetensors",
  "checkpoint_count": 2,
  "elapsed_seconds": 16.066,
  "outputs": [
    {
      "filename": "comfyui_sdxl_smoke_00001_.png",
      "subfolder": "",
      "type": "output"
    }
  ],
  "status": {
    "status_str": "success",
    "completed": true
  }
}
```

ComfyUI log:

```text
Set vram state to: LOW_VRAM
Device: cuda:0 NVIDIA GeForce RTX 4050 Laptop GPU : cudaMallocAsync
DynamicVRAM support detected and enabled
Model SDXL prepared for dynamic VRAM loading. 4896MB Staged.
Prompt executed in 15.01 seconds
```

Imagen:

- Archivo: `images/generated/comfyui_sdxl_smoke_00001_.png`
- Dimensiones: `512x512`
- Modo: `RGB`

## 5. Resultado esperado

Al terminar esta fase, ComfyUI debe:

- Arrancar localmente en `http://127.0.0.1:8188`.
- Detectar CUDA y la RTX 4050.
- Usar modo `LOW_VRAM`.
- Leer checkpoints desde `content-factory/models/checkpoints`.
- Guardar outputs en `content-factory/images/generated`.
- Tener RealVisXL y JuggernautXL disponibles.
- Generar al menos una imagen de prueba.

## 6. Validacion

Estado final:

- ComfyUI clonado: OK.
- ComfyUI API: OK.
- ComfyUI version: `0.22.0`.
- Python venv: OK.
- PyTorch CUDA: OK, `2.11.0+cu128`.
- CUDA disponible en Torch: OK.
- GPU detectada: OK, RTX 4050 Laptop.
- Modo low VRAM: OK.
- DynamicVRAM: OK.
- Directorios extra: OK.
- RealVisXL descargado: OK.
- RealVisXL hash: OK.
- JuggernautXL descargado: OK.
- JuggernautXL hash: OK.
- Checkpoints visibles en ComfyUI: OK, `checkpoint_count=2`.
- Generacion SDXL: OK.
- Imagen generada: OK, `512x512 RGB`.
- VRAM liberada tras apagar ComfyUI: OK, `0 MiB usados / 5921 MiB libres`.
- Espacio libre posterior: `76.64 GiB`.

## Incidencias y correcciones

Incidencia 1:

- ComfyUI reporto: `WARNING: You need pytorch with cu130 or higher to use optimized CUDA operations.`
- Decision: mantener PyTorch `cu128` porque el driver reporta CUDA 12.8. Instalar cu130 no es la ruta correcta para este driver.
- Impacto: no bloquea ComfyUI; solo deshabilita optimizaciones CUDA especificas.

Incidencia 2:

- SDXL completo en 6 GB VRAM tiene margen bajo.
- Correccion: usar `--lowvram`, DynamicVRAM y descargar LLM de VRAM antes de generar imagenes.

Incidencia 3:

- La imagen smoke test se genero borrosa.
- Causa: prueba deliberadamente minima, 512x512, 4 steps, cfg 1.5 para validar carga/inferencia rapido.
- Correccion futura: workflows productivos usaran 1024x1024, mas steps, prompts controlados y posteriormente LoRA/IP-Adapter para consistencia.

## Decision CTO

Fase 4 queda aprobada.

Se puede avanzar a Fase 5:

- Diseñar la influencer virtual Valentina Sol.
- Definir nombre final, biografia, personalidad, estilo, historia y tono.
- Crear `docs/character-profile.md`.
