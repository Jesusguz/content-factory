# Fase 7 - Generador De Contenido Editorial

Fecha: 2026-05-31

## 1. Objetivo

Crear un generador automatico de contenido para Valentina Sol usando Ollama + Qwen3 8B y guardar los resultados en PostgreSQL.

Contenido requerido:

- 20 ideas TikTok.
- 20 captions.
- 20 hooks.
- 20 historias.

## 2. Archivos Creados

- `database/schema.sql`
- `database/generated-content-valentina-sol.sql`
- `scripts/generate_editorial_content.py`
- `docs/content-batch-valentina-sol.json`
- `docs/content-generation-result.json`
- `docs/content-generation.log`
- `docs/content-generation.err.log`

## 3. Codigo Generado

### Schema PostgreSQL

Archivo: `database/schema.sql`

Tablas creadas:

- `characters`
- `content_generation_runs`
- `content_items`

Indices creados:

- `idx_content_items_character_type`
- `idx_content_items_category`
- `idx_content_items_created_at`

Extension usada:

- `pgcrypto`

### Generador Editorial

Archivo: `scripts/generate_editorial_content.py`

Funciones principales:

- Lee `prompts/valentina-sol-llm-system.md`.
- Llama a Ollama por HTTP local.
- Usa modelo `qwen3:8b`.
- Fuerza salida JSON con `format: json`.
- Desactiva thinking con `think: false`.
- Genera cuatro bloques: `tiktok_idea`, `caption`, `hook`, `story`.
- Normaliza categoria, titulo, cuerpo, plataforma y metadata.
- Genera SQL reproducible en `database/generated-content-valentina-sol.sql`.
- Ejecuta `psql` e inserta el lote en PostgreSQL.

Run final:

```text
67db7070-542e-4373-a65e-dba7fba128fd
```

## 4. Comandos Ejecutados

Validacion de sintaxis:

```powershell
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" -c "import ast, pathlib; ast.parse(pathlib.Path('scripts/generate_editorial_content.py').read_text(encoding='utf-8')); print('EDITORIAL_AST_OK')"
```

Aplicar schema:

```powershell
$envMap=@{}
Get-Content database\.env.postgres.local | Where-Object { $_ -match '=' } | ForEach-Object { $k,$v=$_.Split('=',2); $envMap[$k]=$v }
$env:PGPASSWORD=$envMap['POSTGRES_PASSWORD']
& 'C:\Program Files\PostgreSQL\17\bin\psql.exe' -h $envMap['POSTGRES_HOST'] -p $envMap['POSTGRES_PORT'] -U $envMap['POSTGRES_USER'] -d $envMap['POSTGRES_DB'] -v ON_ERROR_STOP=1 -f database\schema.sql
```

Ejecutar generador:

```powershell
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" scripts\generate_editorial_content.py
```

Validar conteo SQL por tipo:

```powershell
SELECT content_type, count(*)
FROM content_items
WHERE run_id = '67db7070-542e-4373-a65e-dba7fba128fd'
GROUP BY content_type
ORDER BY content_type;
```

Validar run y total:

```powershell
SELECT count(*)
FROM content_generation_runs
WHERE id = '67db7070-542e-4373-a65e-dba7fba128fd';

SELECT count(*)
FROM content_items
WHERE run_id = '67db7070-542e-4373-a65e-dba7fba128fd';
```

Liberar modelo Qwen3:

```powershell
ollama stop qwen3:8b
```

## 5. Resultado Esperado

- Generador editorial ejecutable desde CLI.
- 80 piezas generadas por Qwen3 8B.
- 80 piezas insertadas en PostgreSQL.
- Schema listo para que Laravel y n8n consulten contenido.
- Metadata y SQL reproducible guardados en disco.

## 6. Validacion

### Resultado Del Generador

Resultado:

```json
{
  "run_id": "67db7070-542e-4373-a65e-dba7fba128fd",
  "rows_prepared": 80,
  "actual_counts": {
    "tiktok_idea": 20,
    "caption": 20,
    "hook": 20,
    "story": 20
  },
  "inserted_to_postgres": true
}
```

### Conteo JSON

Resultado:

```text
ROWS=80
caption=20
hook=20
story=20
tiktok_idea=20
```

### Conteo PostgreSQL Por Tipo

Resultado:

```text
caption|20
hook|20
story|20
tiktok_idea|20
```

### Conteo PostgreSQL Del Run

Resultado:

```text
1
80
```

Interpretacion:

- Existe 1 fila en `content_generation_runs`.
- Existen 80 filas en `content_items` para ese run.

### Muestra De Contenido

Resultado:

```text
caption | playa | relajado | La brisa de la manana y el sonido del mar son lo mejor para empezar el dia...
caption | cafeteria | calmado | Una taza de cafe recien hecho y una mesa al aire libre...
caption | gym | motivador | No es sobre ser perfecta, es sobre hacer lo que te hace sentir bien...
caption | viajes | aspiracional | Un viaje corto, una ciudad nueva y una mente abierta...
caption | lifestyle | reflexivo | Hoy me enfoque en lo que realmente importa...
```

### VRAM Final

Resultado despues de `ollama stop qwen3:8b`:

```text
0, 5921, 0
```

Interpretacion:

- VRAM usada: 0 MiB.
- VRAM libre: 5921 MiB.
- GPU util: 0%.

## Errores Y Correcciones

### Error 1 - Python Bloqueado Por Sandbox

Sintoma:

```text
Program 'python.exe' failed to run ... Acceso denegado.
```

Causa:

El sandbox de solo lectura bloqueo la ejecucion de Python.

Correccion:

Se ejecuto el comando con permisos elevados y devolvio:

```text
EDITORIAL_AST_OK
```

### Error 2 - UUID No Serializable

Sintoma:

```text
TypeError: Object of type UUID is not JSON serializable
```

Causa:

El generador guardaba `run_id` como objeto `uuid.UUID` dentro de cada fila antes de escribir JSON.

Correccion:

Se cambio `run_id` a string dentro de `normalize_rows`.

Resultado:

```text
ROWS_PREPARED=80
RESULT_JSON=docs/content-generation-result.json
```

### Error 3 - PowerShell ConvertFrom-Json

Sintoma:

```text
The provided JSON includes a property whose name is an empty string...
```

Causa:

Una parte de la metadata cruda generada por el modelo incluyo una clave vacia. El JSON seguia siendo valido, pero PowerShell no lo acepta sin `-AsHashTable`.

Correccion:

Se valido el JSON con Python y se verifico PostgreSQL directamente.

### Error 4 - Ollama Stop En Sandbox

Sintoma:

```text
ollama.exe failed to run ... Acceso denegado.
```

Causa:

El sandbox bloqueo la ejecucion de `ollama.exe`.

Correccion:

Se ejecuto `ollama stop qwen3:8b` con permisos elevados y VRAM quedo libre.

## Decision CTO

Fase 7 queda aprobada.

El generador editorial existe, produce contenido estructurado con Qwen3 8B, guarda el lote en disco, genera SQL reproducible e inserta correctamente 80 piezas en PostgreSQL.
