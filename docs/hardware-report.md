# Fase 1 - Hardware Report

Fecha de auditoria: 2026-05-31 11:30 America/Mexico_City
Workspace: `C:\Users\magdi\Documents\Codex\2026-05-31\goal-construir-una-f-brica-de\content-factory`

## 1. Objetivo

Auditar el sistema local Windows 11 antes de instalar la fabrica de contenido IA.

Alcance verificado:

- CPU
- RAM
- GPU
- CUDA disponible por driver NVIDIA
- CUDA Toolkit / `nvcc`
- Espacio libre en disco
- Estructura base del proyecto

## 2. Archivos creados

Directorios creados:

- `content-factory/backend`
- `content-factory/frontend`
- `content-factory/database`
- `content-factory/workflows`
- `content-factory/comfyui`
- `content-factory/models`
- `content-factory/assets`
- `content-factory/videos`
- `content-factory/images`
- `content-factory/prompts`
- `content-factory/scripts`
- `content-factory/docs`

Archivo creado:

- `content-factory/docs/hardware-report.md`

## 3. Codigo generado

No se genero codigo ejecutable en esta fase.

Se genero este reporte Markdown como artefacto de auditoria tecnica.

## 4. Comandos ejecutados

```powershell
Get-Location
Get-ChildItem -Force
```

```powershell
$cpu=Get-CimInstance Win32_Processor
"CPU_NAME=$($cpu.Name)"
"CPU_CORES=$($cpu.NumberOfCores)"
"CPU_THREADS=$($cpu.NumberOfLogicalProcessors)"
"CPU_MAX_MHZ=$($cpu.MaxClockSpeed)"
$cs=Get-CimInstance Win32_ComputerSystem
"RAM_BYTES=$($cs.TotalPhysicalMemory)"
"RAM_GB=$([math]::Round($cs.TotalPhysicalMemory/1GB,2))"
$os=Get-CimInstance Win32_OperatingSystem
"OS=$($os.Caption)"
"OS_VERSION=$($os.Version)"
"OS_BUILD=$($os.BuildNumber)"
"OS_ARCH=$($os.OSArchitecture)"
```

```powershell
$gpu=Get-CimInstance Win32_VideoController
foreach($g in $gpu){
  "GPU_NAME=$($g.Name)"
  "GPU_ADAPTER_RAM_BYTES=$($g.AdapterRAM)"
  "GPU_DRIVER=$($g.DriverVersion)"
}
```

```powershell
$drive=((Get-Location).Drive.Name + ':')
$disk=Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$drive'"
"DRIVE=$($disk.DeviceID)"
"DISK_FREE_BYTES=$($disk.FreeSpace)"
"DISK_SIZE_BYTES=$($disk.Size)"
"DISK_FREE_GB=$([math]::Round($disk.FreeSpace/1GB,2))"
"DISK_SIZE_GB=$([math]::Round($disk.Size/1GB,2))"
```

```powershell
nvidia-smi
nvidia-smi --query-gpu=name,driver_version,memory.total,memory.used,memory.free,temperature.gpu,power.draw,power.limit,utilization.gpu --format=csv,noheader,nounits
nvcc --version
```

```powershell
$root = Join-Path (Get-Location) 'content-factory'
$dirs = @('backend','frontend','database','workflows','comfyui','models','assets','videos','images','prompts','scripts','docs')
New-Item -ItemType Directory -Force -Path $root | Out-Null
foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force -Path (Join-Path $root $d) | Out-Null
}
Get-ChildItem -Directory $root | Select-Object Name
```

## 5. Resultado esperado

El sistema debe cumplir con los requisitos minimos para ejecutar:

- Ollama con modelo `qwen3:8b`.
- ComfyUI con checkpoints SDXL usando la RTX 4050 Laptop.
- PostgreSQL local.
- n8n local.
- Laravel 12.
- FFmpeg para video corto.

Resultado tecnico esperado para este hardware:

- LLM local viable, con preferencia por cuantizacion en Ollama.
- SDXL viable en ComfyUI con optimizaciones de memoria por 6 GB VRAM.
- Generacion de video por FFmpeg viable en CPU/GPU segun codecs disponibles.
- 109.22 GB libres: suficiente para fase inicial, pero ajustado para multiples checkpoints, datasets y videos. Se recomienda reservar 150-250 GB a mediano plazo.

## 6. Validacion

### Sistema operativo

- OS: Microsoft Windows 11 Home Single Language
- Version: 10.0.26200
- Build: 26200
- Arquitectura: 64 bits

Estado: OK.

### CPU

- Modelo: AMD Ryzen 5 7535HS with Radeon Graphics
- Nucleos fisicos: 6
- Hilos logicos: 12
- Frecuencia maxima reportada: 3301 MHz

Estado: OK para automatizacion local, Laravel, PostgreSQL, n8n, FFmpeg y cargas auxiliares.

### RAM

- RAM fisica reportada: 16,369,414,144 bytes
- RAM utilizable aproximada: 15.25 GiB

Estado: OK con restricciones. Para SDXL + Ollama + servicios simultaneos se deben evitar cargas concurrentes pesadas.

### GPU

GPUs detectadas por WMI:

- AMD Radeon(TM) Graphics
- NVIDIA GeForce RTX 4050 Laptop GPU

GPU NVIDIA verificada por `nvidia-smi`:

- Nombre: NVIDIA GeForce RTX 4050 Laptop GPU
- Driver NVIDIA: 572.83
- VRAM total: 6141 MiB
- VRAM usada al auditar: 8 MiB
- VRAM libre al auditar: 5914 MiB
- Temperatura: 47 C
- Utilizacion GPU: 0%
- Potencia al auditar: 2 W / 79 W

Estado: OK para ComfyUI SDXL con perfiles de baja VRAM.

Nota: `Win32_VideoController.AdapterRAM` reporto 4,293,918,720 bytes para la NVIDIA, pero en laptops/WDDM ese valor puede ser incompleto. Para VRAM se toma `nvidia-smi` como fuente autoritativa.

### CUDA

- `nvidia-smi` reporta: CUDA Version 12.8
- `nvcc --version`: fallo; `nvcc` no esta instalado o no esta en PATH.

Estado: Parcialmente OK.

Interpretacion:

- El driver NVIDIA soporta CUDA 12.8.
- CUDA Toolkit no esta instalado como herramienta de compilacion.
- Para ComfyUI con PyTorch en Windows no es obligatorio instalar CUDA Toolkit si se usan wheels CUDA precompilados.

### Disco

- Unidad auditada: C:
- Capacidad total: 449.47 GiB
- Espacio libre: 109.22 GiB

Estado: OK para instalacion inicial.

Riesgo:

- RealVisXL, JuggernautXL, ComfyUI, caches de Python, Ollama, PostgreSQL, imagenes y videos pueden consumir el espacio rapidamente.
- Se debe controlar retencion de outputs y caches desde Fase 4 en adelante.

### Incidencias y correcciones

Incidencia 1:

- Comando: `nvidia-smi --query-gpu=name,driver_version,cuda_version,...`
- Resultado: fallo porque `cuda_version` no es campo valido para `--query-gpu` en esta version.
- Correccion: se ejecuto `nvidia-smi` estandar para leer `CUDA Version: 12.8`.

Incidencia 2:

- Comando: `nvcc --version`
- Resultado: `nvcc` no reconocido.
- Correccion: se documenta CUDA Toolkit ausente. No bloquea Fase 2 ni instalacion base de ComfyUI con PyTorch precompilado.

## Decision CTO

Fase 1 queda aprobada.

Se puede avanzar a Fase 2 con estas decisiones:

- Instalar/verificar Git, Python, Ollama y PostgreSQL.
- Mantener ComfyUI y modelos dentro de `content-factory` o rutas controladas.
- Usar configuracion low VRAM para SDXL.
- No instalar CUDA Toolkit salvo que algun custom node lo requiera.
