# Fase 3 - LLM Report

Fecha de ejecucion: 2026-05-31 America/Mexico_City
Workspace: `C:\Users\magdi\Documents\Codex\2026-05-31\goal-construir-una-f-brica-de\content-factory`

## 1. Objetivo

Instalar y validar el modelo principal de lenguaje local:

- Runtime: Ollama
- Modelo: `qwen3:8b`
- Medicion requerida:
  - Tiempo de respuesta
  - Consumo RAM
  - Consumo VRAM

## 2. Archivos creados

- `content-factory/scripts/measure_ollama_qwen3.py`
- `content-factory/docs/llm-benchmark-qwen3-8b.json`
- `content-factory/docs/llm-report.md`

Archivos/directorios usados:

- `content-factory/models/ollama`

Nota:

- `models/ollama/` fue agregado a `.gitignore`; los modelos son artefactos pesados y no deben versionarse.

## 3. Codigo generado

Se genero `scripts/measure_ollama_qwen3.py` para ejecutar una prueba fria y una prueba caliente contra Ollama usando la API local.

El script:

- Llama `http://127.0.0.1:11434/api/generate`.
- Usa `think=false` para evitar que Qwen3 entregue solo el campo `thinking`.
- Mide tiempo total, tiempo de carga, tokens por segundo y longitud de respuesta.
- Muestrea:
  - Working set del proceso `ollama`.
  - RAM libre/usada del sistema.
  - VRAM usada/libre con `nvidia-smi`.
  - Utilizacion GPU.

Configuracion clave:

```python
payload = {
    "model": "qwen3:8b",
    "stream": False,
    "think": False,
    "keep_alive": "10m",
    "options": {
        "temperature": 0.6,
        "num_ctx": 2048,
    },
}
```

## 4. Comandos ejecutados

### Configuracion ruta local de modelos

```powershell
$models = Join-Path (Get-Location) 'models\ollama'
New-Item -ItemType Directory -Force -Path $models
[Environment]::SetEnvironmentVariable('OLLAMA_MODELS', $models, 'User')
$env:OLLAMA_MODELS = $models
Get-Process | Where-Object { $_.ProcessName -match '^ollama' } | Stop-Process -Force
Start-Process -FilePath "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" -ArgumentList 'serve' -WindowStyle Hidden
Invoke-RestMethod -Uri http://127.0.0.1:11434/api/tags -Method Get
```

Resultado:

- Ollama reiniciado.
- API local activa.
- `OLLAMA_MODELS` apunta a `content-factory\models\ollama`.

### Descarga modelo

```powershell
$env:OLLAMA_MODELS = Join-Path (Get-Location) 'models\ollama'
$ollama = Join-Path $env:LOCALAPPDATA 'Programs\Ollama\ollama.exe'
$before = Get-Date
& $ollama pull qwen3:8b
$after = Get-Date
& $ollama list
```

Resultado:

```text
OLLAMA_PULL_EXIT=0
OLLAMA_PULL_SECONDS=2598.8
NAME        ID              SIZE      MODIFIED
qwen3:8b    500a1f067a9f    5.2 GB    Less than a second ago
```

### Metadata modelo

```powershell
& $ollama show qwen3:8b
```

Resultado:

- Arquitectura: `qwen3`
- Parametros: `8.2B`
- Context length: `40960`
- Embedding length: `4096`
- Cuantizacion: `Q4_K_M`
- Capabilities: `completion`, `tools`, `thinking`
- Licencia: Apache 2.0

### Benchmark

```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" stop qwen3:8b
Start-Sleep -Seconds 5
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" scripts\measure_ollama_qwen3.py
```

### Validacion adicional

```powershell
Get-ChildItem models\ollama -Recurse -File | Measure-Object -Property Length -Sum
nvidia-smi --query-gpu=name,memory.total,memory.used,memory.free,utilization.gpu --format=csv,noheader,nounits
```

## 5. Resultado esperado

El modelo debe:

- Estar instalado en Ollama.
- Responder por API local.
- Generar texto util para contenido.
- Usar la RTX 4050 Laptop cuando sea posible.
- Mantener consumo dentro de 6 GB VRAM y 16 GB RAM.

Resultado esperado para este hardware:

- `qwen3:8b` cuantizado `Q4_K_M` debe caber casi completo en VRAM.
- El margen de VRAM queda estrecho; no se debe ejecutar SDXL en ComfyUI al mismo tiempo que el LLM cargado.
- Para pipelines diarios, se recomienda secuenciar: generar texto -> descargar modelo de memoria -> generar imagen/video.

## 6. Validacion

### Instalacion modelo

- Modelo: `qwen3:8b`
- ID: `500a1f067a9f`
- Tamano reportado por Ollama: `5.2 GB`
- Tamano real en `models/ollama`: `5,225,389,023` bytes (`4.867 GiB`)
- Descarga: `2598.8` segundos
- Estado: OK

### Prueba fria

Prompt:

```text
Responde en una frase corta: sistema local listo para Valentina Sol.
```

Respuesta:

```text
Sistema local listo para Valentina Sol.
```

Metricas:

- Wall time: `7.932 s`
- Ollama total: `7.025 s`
- Carga de modelo: `6.597 s`
- Tokens generados: `11`
- Velocidad: `35.8 tokens/s`
- Working set maximo Ollama: `882.88 MB`
- RAM sistema usada maxima: `11.468 GiB`
- VRAM maxima usada: `5155 MiB`
- VRAM minima libre: `767 MiB`
- GPU util maxima: `95%`

Estado: OK.

### Prueba caliente

Prompt:

```text
Genera 5 ideas breves de TikTok para una influencer virtual IA de lifestyle llamada Valentina Sol. Formato numerado, maximo 12 palabras por idea.
```

Respuesta generada:

```text
1. Valentina Sol muestra su rutina matutina con IA en la cocina.
2. Valentina Sol prueba un nuevo look con IA en la calle.
3. Valentina Sol ensena a usar IA para organizar el dia.
4. Valentina Sol comparte consejos de IA para el bienestar.
5. Valentina Sol vive un dia con IA en la oficina.
```

Metricas:

- Wall time: `3.929 s`
- Ollama total: `2.629 s`
- Carga de modelo: `0.177 s`
- Tokens generados: `85`
- Velocidad: `35.56 tokens/s`
- Working set maximo Ollama: `938.72 MB`
- RAM sistema usada maxima: `11.387 GiB`
- VRAM maxima usada: `5155 MiB`
- VRAM minima libre: `767 MiB`
- GPU util maxima: `96%`

Estado: OK.

### Estado GPU posterior

```text
NVIDIA GeForce RTX 4050 Laptop GPU, 6141 MiB total, 5155 MiB usados, 767 MiB libres, 0% util
```

Interpretacion:

- El modelo queda cargado en VRAM por `keep_alive`.
- Para liberar VRAM antes de ComfyUI:

```powershell
ollama stop qwen3:8b
```

### Disco posterior

- Espacio libre en C: despues de instalar dependencias y modelo: `89.49 GiB`

Estado: OK para seguir, pero ya existe presion de disco.

## Incidencias y correcciones

Incidencia 1:

- Benchmark inicial produjo `response_chars=0`.
- Causa: Qwen3 tiene capability `thinking`; la API devolvio texto en el campo `thinking` cuando no se desactivo.
- Correccion: agregar `think=false` al payload de `/api/generate`.
- Resultado: respuestas textuales correctas.

Incidencia 2:

- `qwen3:8b` consume `5155 MiB` de VRAM en la RTX 4050 de `6141 MiB`.
- Causa: modelo cuantizado Q4_K_M entra en GPU, pero deja margen bajo.
- Correccion operativa: no mantener LLM cargado durante Fase 4/ComfyUI; liberar con `ollama stop qwen3:8b`.

## Decision CTO

Fase 3 queda aprobada.

Se puede avanzar a Fase 4 con estas reglas:

- Instalar ComfyUI con PyTorch CUDA compatible.
- Usar modo low VRAM para SDXL.
- Descargar o ubicar checkpoints SDXL en `models/checkpoints`.
- Descargar `qwen3:8b` de VRAM antes de probar ComfyUI.
- Documentar todo en `docs/comfyui-report.md`.
