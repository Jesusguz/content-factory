# Fase 2 - Installation Report

Fecha de ejecucion: 2026-05-31 America/Mexico_City
Workspace: `C:\Users\magdi\Documents\Codex\2026-05-31\goal-construir-una-f-brica-de\content-factory`

## 1. Objetivo

Instalar y verificar las dependencias base de la fabrica de contenido:

- Git
- Python
- Ollama
- PostgreSQL

Tambien se dejo una base PostgreSQL inicial para fases posteriores.

## 2. Archivos creados

- `content-factory/.gitignore`
- `content-factory/database/.env.postgres.example`
- `content-factory/database/.env.postgres.local`
- `content-factory/docs/installation-report.md`

Archivos auxiliares descargados/generados:

- `content-factory/scripts/OllamaSetup.exe`
- `content-factory/scripts/ollama-install.log`

Nota: `.env.postgres.local`, instaladores y logs estan excluidos por `.gitignore`.

Repositorio:

- `content-factory/.git` inicializado con `git init`.

## 3. Codigo generado

### `.gitignore`

```gitignore
# Local credentials
*.local
*.env
!.env.example
!*.example

# Python
__pycache__/
*.py[cod]
.venv/
venv/

# Node / Laravel / n8n
node_modules/
vendor/
.env.*
!.env.example

# Generated media and model artifacts
images/generated/
videos/generated/
assets/generated/
models/checkpoints/
models/loras/
models/vae/
models/controlnet/
comfyui/ComfyUI/

# Logs and temporary installers
*.log
scripts/*.exe
scripts/*.msi
scripts/*.zip
```

### `database/.env.postgres.example`

```env
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_DB=content_factory
POSTGRES_USER=content_factory_app
POSTGRES_PASSWORD=change_me

POSTGRES_ADMIN_DB=postgres
POSTGRES_ADMIN_USER=postgres
POSTGRES_ADMIN_PASSWORD=change_me
```

### PostgreSQL bootstrap aplicado

```sql
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'content_factory_app') THEN
    CREATE ROLE content_factory_app LOGIN PASSWORD 'ContentFactoryApp_2026!';
  ELSE
    ALTER ROLE content_factory_app WITH LOGIN PASSWORD 'ContentFactoryApp_2026!';
  END IF;
END $$;
```

```sql
CREATE DATABASE content_factory OWNER content_factory_app;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
GRANT ALL PRIVILEGES ON DATABASE content_factory TO content_factory_app;
```

## 4. Comandos ejecutados

### Deteccion inicial

```powershell
git --version
python --version
py -0p
ollama --version
psql --version
postgres --version
winget --version
```

Resultados iniciales:

- Git instalado: `git version 2.49.0.windows.1`
- Python no estaba instalado como binario real en PATH; solo alias de Microsoft Store.
- Ollama no estaba instalado.
- PostgreSQL no estaba instalado.
- winget disponible: `v1.28.240`

### Inicializacion Git

```powershell
git init
git status --short
```

Resultado:

- Repositorio Git local inicializado en `content-factory`.
- `.gitignore` protege credenciales locales, instaladores, logs, modelos y medios generados.

### Busqueda de paquetes

```powershell
winget search --id Python.Python.3.11 --exact --source winget --accept-source-agreements
winget search --id Ollama.Ollama --exact --source winget --accept-source-agreements
winget search postgresql --source winget --accept-source-agreements
```

Paquetes seleccionados:

- Python 3.11: `Python.Python.3.11` version `3.11.9`
- Ollama: `Ollama.Ollama` version `0.24.0`
- PostgreSQL: `PostgreSQL.PostgreSQL.17` version `17.10-1`

Decision CTO:

- PostgreSQL 17 fue elegido sobre PostgreSQL 18 por estabilidad de ecosistema para Laravel y automatizaciones locales.

### Instalacion Python

```powershell
winget install --id Python.Python.3.11 --exact --source winget --accept-package-agreements --accept-source-agreements --silent
```

Correccion PATH:

```powershell
$pythonRoot = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python311'
$pythonScripts = Join-Path $pythonRoot 'Scripts'
[Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
```

PATH final de usuario prioriza:

- `C:\Users\magdi\AppData\Local\Programs\Python\Python311`
- `C:\Users\magdi\AppData\Local\Programs\Python\Python311\Scripts`
- `C:\Users\magdi\AppData\Local\Programs\Ollama`
- `C:\Program Files\PostgreSQL\17\bin`

Validacion:

```powershell
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" --version
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" -m pip --version
& "C:\Windows\py.exe" -0p
```

Resultado:

- Python: `Python 3.11.9`
- pip: `pip 24.0`
- py launcher detecta: `C:\Users\magdi\AppData\Local\Programs\Python\Python311\python.exe`

### Instalacion Ollama

Intentos fallidos:

```powershell
winget install --id Ollama.Ollama --exact --source winget --accept-package-agreements --accept-source-agreements --silent
winget install --id Ollama.Ollama --exact --source winget --accept-package-agreements --accept-source-agreements --disable-interactivity --override "/VERYSILENT /NORESTART"
```

Problema:

- `winget install` agoto tiempo y dejo procesos colgados porque el instalador oficial de Ollama 0.24.0 pesa aproximadamente 2.13 GB.

Correccion:

```powershell
curl.exe -L --retry 20 --retry-all-errors --retry-delay 5 --connect-timeout 30 --speed-time 180 --speed-limit 1024 -C - -o scripts\OllamaSetup.exe https://github.com/ollama/ollama/releases/download/v0.24.0/OllamaSetup.exe
Get-FileHash scripts\OllamaSetup.exe -Algorithm SHA256
```

Resultado de descarga:

- Tamano: `2,129,194,472` bytes
- SHA256: `C445439B0101F0CC6A3419A4A198353472DBEF22028843E4FC10203EF7352C75`
- El hash coincide con el manifest oficial de `winget`.

Instalacion silenciosa:

```powershell
$installer = Resolve-Path scripts\OllamaSetup.exe
$log = Join-Path (Get-Location) 'scripts\ollama-install.log'
Start-Process -FilePath $installer -ArgumentList '/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART',('/LOG="' + $log + '"') -WindowStyle Hidden -PassThru
```

Validacion:

```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" --version
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" list
Invoke-RestMethod -Uri http://127.0.0.1:11434/api/tags -Method Get
```

Resultado:

- Ollama: `0.24.0`
- Binario: `C:\Users\magdi\AppData\Local\Programs\Ollama\ollama.exe`
- API local: responde en `http://127.0.0.1:11434`
- Modelos instalados todavia: ninguno. Esto corresponde a Fase 3.

### Instalacion PostgreSQL

```powershell
winget install --id PostgreSQL.PostgreSQL.17 --exact --source winget --accept-package-agreements --accept-source-agreements --disable-interactivity --override "--mode unattended --unattendedmodeui none --superpassword ValentinaSolLocal_2026! --serverport 5432 --locale C --disable-components stackbuilder"
```

Validacion sistema:

```powershell
Get-Service -Name 'postgresql*'
Test-NetConnection -ComputerName 127.0.0.1 -Port 5432
winget list --id PostgreSQL.PostgreSQL.17 --exact --source winget --accept-source-agreements
```

Resultado:

- Servicio: `postgresql-x64-17`
- Estado: `Running`
- Inicio: `Automatic`
- Puerto: `5432`
- Conectividad TCP: `True`
- Version winget: `17.10-1`

Validacion SQL:

```powershell
$env:PGPASSWORD='ValentinaSolLocal_2026!'
& 'C:\Program Files\PostgreSQL\17\bin\psql.exe' -h 127.0.0.1 -p 5432 -U postgres -d postgres -c "SELECT version();"
```

Resultado:

```text
PostgreSQL 17.10 on x86_64-windows, compiled by msvc-19.44.35226, 64-bit
```

Base inicial:

```powershell
$env:PGPASSWORD='ContentFactoryApp_2026!'
& 'C:\Program Files\PostgreSQL\17\bin\psql.exe' -h 127.0.0.1 -p 5432 -U content_factory_app -d content_factory -c "SELECT current_database(), current_user;"
```

Resultado:

```text
current_database | current_user
content_factory  | content_factory_app
```

## 5. Resultado esperado

Al terminar la fase:

- Git debe responder por CLI.
- Python 3.11 debe estar instalado y utilizable para scripts y ComfyUI.
- Ollama debe estar instalado y responder por API local.
- PostgreSQL debe estar instalado, activo en `127.0.0.1:5432`, y aceptar conexiones.
- Debe existir una base local `content_factory` para fases de contenido y dashboard.

## 6. Validacion

Estado final:

- Git: OK.
- Python 3.11: OK con ruta explicita y `py.exe`; PATH de nuevas shells de usuario puede requerir reinicio de terminal para reflejar cambios.
- pip: OK con Python 3.11.
- Ollama 0.24.0: OK.
- Ollama API local: OK.
- PostgreSQL 17.10: OK.
- Servicio PostgreSQL: OK, `postgresql-x64-17` en `Running` y `Automatic`.
- Base `content_factory`: OK.
- Usuario `content_factory_app`: OK.
- Extension `pgcrypto`: OK.

Incidencias corregidas:

1. `winget search` intento usar `msstore` y pidio contratos interactivos.
   - Correccion: usar `--source winget --accept-source-agreements`.
2. Python quedo detras del alias `WindowsApps`.
   - Correccion: se agregaron Python 3.11 y Scripts al PATH de usuario; para automatizacion se validan rutas explicitas.
3. `winget install` de Ollama agoto tiempo.
   - Correccion: descarga reanudable con `curl.exe -C -`, verificacion SHA256 y ejecucion silenciosa manual.
4. Primer script de bootstrap PostgreSQL fallo al llamar `.Trim()` sobre una consulta vacia.
   - Correccion: conversion segura con `Out-String` y ejecucion idempotente.

## Decision CTO

Fase 2 queda aprobada.

Se puede avanzar a Fase 3:

- Descargar `qwen3:8b` en Ollama.
- Verificar respuesta del modelo.
- Medir tiempo de respuesta, RAM y VRAM.
- Crear `docs/llm-report.md`.
