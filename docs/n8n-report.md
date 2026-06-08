# Fase 9 - n8n Y Workflows

Fecha: 2026-05-31

## 1. Objetivo

Instalar n8n y crear workflows para automatizar la fabrica de contenido de Valentina Sol.

Workflows requeridos:

- Generar contenido diario.
- Generar imagenes.
- Crear videos.
- Programar publicaciones.

## 2. Archivos Creados

- `scripts/n8n_generate_daily_content.ps1`
- `scripts/n8n_generate_images.ps1`
- `scripts/n8n_create_video.ps1`
- `scripts/n8n_schedule_publication.ps1`
- `workflows/generate-daily-content.json`
- `workflows/generate-images.json`
- `workflows/create-videos.json`
- `workflows/schedule-publications.json`
- `docs/n8n-exported-workflows.json`
- `docs/n8n-server-out.log`
- `docs/n8n-server-err.log`
- `docs/n8n-server.pid`
- `n8n-runtime/` (ignorado por Git)
- `n8n-user/` (ignorado por Git)

Schema actualizado:

- `database/schema.sql`
- Tabla nueva: `publication_queue`

## 3. Codigo Generado

### Wrappers PowerShell

`scripts/n8n_generate_daily_content.ps1`

- Ejecuta `scripts/generate_editorial_content.py`.
- Genera 80 piezas editoriales y las inserta en PostgreSQL.

`scripts/n8n_generate_images.ps1`

- Arranca ComfyUI en segundo plano.
- Espera API `http://127.0.0.1:8188/system_stats`.
- Genera 5 imagenes diarias de validacion.
- Guarda metadata diaria JSON/CSV.
- Detiene ComfyUI y sus procesos hijos.

`scripts/n8n_create_video.ps1`

- Ejecuta `scripts/create_short_video.py`.
- Regenera MP4 vertical con subtitulos.

`scripts/n8n_schedule_publication.ps1`

- Inserta una fila en `publication_queue`.
- Programa la publicacion para `now() + interval '1 day'`.
- Asocia caption, plataforma y ruta del video.

### Workflows n8n

Cada workflow tiene:

- Manual Trigger.
- Schedule Trigger.
- Execute Command.

Horarios:

- Contenido diario: `0 8 * * *`
- Imagenes: `30 8 * * *`
- Videos: `0 9 * * *`
- Publicaciones: `30 9 * * *`

## 4. Comandos Ejecutados

Verificar Node/npm:

```powershell
node -v
npm -v
```

Consultar n8n:

```powershell
npm view n8n version engines --json
```

Actualizar Node:

```powershell
winget upgrade --id OpenJS.NodeJS.22 -e --accept-source-agreements --accept-package-agreements --silent
```

Instalar n8n local:

```powershell
npm install --prefix n8n-runtime n8n@2.22.5
```

Verificar n8n:

```powershell
.\n8n-runtime\node_modules\.bin\n8n.cmd --version
```

Importar workflows:

```powershell
$env:N8N_USER_FOLDER=(Join-Path (Get-Location) 'n8n-user')
$env:N8N_DIAGNOSTICS_ENABLED='false'
$env:N8N_VERSION_NOTIFICATIONS_ENABLED='false'
.\n8n-runtime\node_modules\.bin\n8n.cmd import:workflow --separate --input workflows
```

Exportar workflows importados:

```powershell
.\n8n-runtime\node_modules\.bin\n8n.cmd export:workflow --all --output docs\n8n-exported-workflows.json
```

Arrancar n8n:

```powershell
.\n8n-runtime\node_modules\.bin\n8n.cmd start
```

Verificar health:

```powershell
Invoke-WebRequest -Uri 'http://127.0.0.1:5678/healthz'
```

## 5. Resultado Esperado

- Node compatible con n8n.
- n8n instalado localmente en el proyecto.
- Workflows JSON creados.
- Workflows importables por n8n.
- n8n arranca en localhost.
- Health endpoint responde.
- Scripts ejecutables por n8n validados.
- Cola de publicaciones guardada en PostgreSQL.

## 6. Validacion

### Node/npm

Resultado:

```text
v22.22.3
10.9.8
```

### n8n Disponible

Resultado:

```text
2.22.5
```

### Requisito n8n

Resultado:

```json
{
  "version": "2.22.5",
  "engines": {
    "node": ">=22.16"
  }
}
```

### JSON Workflows

Resultado:

```text
JSON_OK=create-videos.json|Valentina Sol - Crear videos|nodes=3
JSON_OK=generate-daily-content.json|Valentina Sol - Generar contenido diario|nodes=3
JSON_OK=generate-images.json|Valentina Sol - Generar imagenes|nodes=3
JSON_OK=schedule-publications.json|Valentina Sol - Programar publicaciones|nodes=3
```

### Import n8n

Resultado:

```text
Importing 4 workflows...
Successfully imported 4 workflows.
```

### Export n8n

Resultado:

```text
Successfully exported 4 workflows.
EXPORTED=4
Valentina Sol - Crear videos|active=False|nodes=3
Valentina Sol - Generar contenido diario|active=False|nodes=3
Valentina Sol - Generar imagenes|active=False|nodes=3
Valentina Sol - Programar publicaciones|active=False|nodes=3
```

### Server Health

Resultado:

```text
N8N_HEALTH=200
n8n ready on ::, port 5678
n8n Task Broker ready on 127.0.0.1, port 5679
```

### Wrappers

Programacion:

```text
INSERT 0 1
publication_queue: scheduled|1
```

Imagenes:

```text
DATASET_TOTAL=5
DATASET_ROWS=5
COMFYUI_API=down
GPU=0, 5921, 0
```

Video:

```json
{
  "status": "ok",
  "output": "videos/generated/valentina_sol_lifestyle_short.mp4",
  "srt": "videos/generated/valentina_sol_lifestyle_short.srt",
  "image_count": 6
}
```

### Servidor Detenido

Resultado:

```text
N8N_API=down
```

## Errores Y Correcciones

### Error 1 - n8n Requeria Node Mas Nuevo

Sintoma:

```json
"node": ">=22.16"
```

La maquina tenia:

```text
v22.14.0
```

Correccion:

Se actualizo Node con winget a:

```text
v22.22.3
```

### Error 2 - Paquete LTS No Encontrado

Sintoma:

```text
No se encontro ningun paquete que coincida con los criterios de entrada.
```

Causa:

El paquete instalado no era `OpenJS.NodeJS.LTS`, sino `OpenJS.NodeJS.22`.

Correccion:

Se uso:

```powershell
winget upgrade --id OpenJS.NodeJS.22
```

### Error 3 - Instalacion Global n8n No Visible

Sintoma:

```text
n8n: The term 'n8n' is not recognized
npm list -g n8n --depth=0 -> empty
```

Causa:

La instalacion global no quedo accesible en el prefix del usuario actual.

Correccion:

Se instalo n8n local en:

```text
n8n-runtime/
```

### Error 4 - Import Con activeState

Sintoma:

```text
The "--activeState=fromJson" flag can only be used when n8n is running in queue or multi-main mode.
```

Correccion:

Se reimporto sin `--activeState`. Los workflows quedaron desactivados por seguridad.

### Error 5 - Tags En Import

Sintoma:

```text
SQLITE_CONSTRAINT: NOT NULL constraint failed: workflows_tags.tagId
```

Causa:

Los JSON incluian tags que no existian en la base local de n8n.

Correccion:

Se quitaron los tags de los workflows JSON.

### Warning - Python Task Runner

Mensaje:

```text
Failed to start Python task runner in internal mode...
```

Impacto:

No bloquea esta fase. Los workflows usan `Execute Command` para llamar scripts PowerShell/Python del sistema, no el Python task runner interno de n8n.

## Decision CTO

Fase 9 queda aprobada.

n8n esta instalado como runtime local, arranca en localhost, importa/exporta 4 workflows y los wrappers ejecutan contenido, imagenes, video y programacion con estado persistido en PostgreSQL.
