# Consistency Report - Elena Voss

Fecha local: 2026-06-07
Fecha UTC de resultados: 2026-06-08

## 1. Objetivo

Convertir `content-factory` en un sistema centrado en una unica identidad digital: Elena Voss.

Regla aplicada:

- No publicar.
- No aprobar.
- No incluir en calendario.
- No escalar produccion.
- Bloquear todo lote con ISI < 90.

## 2. Archivos creados o actualizados

- `STATUS.md`
- `identity_bible.json`
- `prompts/elena-voss-image-positive.txt`
- `prompts/elena-voss-image-negative.txt`
- `prompts/elena-voss-llm-system.md`
- `scripts/select_lora_dataset.py`
- `scripts/consistency_score.py`
- `scripts/generate_valentina_dataset.py`
- `scripts/generate_today.ps1`
- `scripts/n8n_generate_images.ps1`
- `scripts/n8n_schedule_publication.ps1`
- `training/elena_lora_dataset.toml`
- `scripts/train_elena_lora.ps1`
- `backend/routes/web.php`
- `backend/resources/views/dashboard.blade.php`
- `database/schema.sql`
- `dataset_lora/metadata.json`
- `dataset_lora/selected.csv`
- `dataset_lora/audit.csv`
- `docs/generate-today-result.json`
- `docs/consistency-score-latest.json`
- `docs/consistency-score-refined-dataset.json`
- `docs/consistency-score-best-self-audit.json`
- `docs/elena-daily-best-rejected-contact-sheet.jpg`

## 3. Codigo generado

Se implemento:

- Selector LoRA con filtros de rostro, pose, blur, terminos prohibidos y cluster facial.
- Score de consistencia:
  - Face Consistency.
  - Body Consistency.
  - Style Consistency.
  - Narrative Consistency.
  - Global Score.
  - Identity Stability Index (ISI).
- Gate de bloqueo:
  - `approved=false` si cualquier metrica critica queda bajo objetivo.
  - `gate_status=rejected` si ISI < 90.
- Generacion diaria:
  - LoRA obligatoria.
  - 5 categorias balanceadas.
  - Semilla fija para reducir deriva.
  - Rechazo automatico por consistency gate.
- Dashboard:
  - Boton `GENERAR CONTENIDO DE HOY`.
  - Scores visibles.
  - Identity Stability Index (ISI) visible.
  - Estado de bloqueo visible.
- PostgreSQL:
  - Tablas `consistency_batches` y `consistency_items`.

## 4. Comandos ejecutados

Principales comandos verificados:

```powershell
& quality\.venv\Scripts\python.exe scripts\select_lora_dataset.py --target-count 30 --min-count 30
```

```powershell
& quality\.venv\Scripts\python.exe scripts\consistency_score.py --reference-metadata dataset_lora\metadata.json --target-metadata dataset_lora\metadata.json --batch-name elena_lora_dataset_refined_audit --result-json docs\consistency-score-refined-dataset.json --sql-file database\consistency-score-refined-dataset.sql --skip-db
```

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\generate_today.ps1
```

```powershell
& quality\.venv\Scripts\python.exe scripts\consistency_score.py --reference-metadata docs\daily-elena-images-20260607-194019.json --target-metadata docs\daily-elena-images-20260607-194019.json --batch-name elena_daily_best_self_audit --result-json docs\consistency-score-best-self-audit.json --sql-file database\consistency-score-best-self-audit.sql --min-reference-faces 5 --min-reference-bodies 3 --skip-db
```

```powershell
Invoke-WebRequest -Uri http://127.0.0.1:8000 -UseBasicParsing -TimeoutSec 20
```

```powershell
php artisan test --filter ExampleTest
```

```powershell
php artisan route:list
```

## 5. Resultado esperado

El sistema debia:

- Generar contenido diario desde el dashboard.
- Usar obligatoriamente `elena_voss_v1.safetensors`.
- Calcular Consistency Score.
- Guardar resultados en PostgreSQL.
- Rechazar lotes con ISI < 90.
- No publicar contenido rechazado.
- Mostrar en dashboard `Identity Stability Index (ISI)`.

## 6. Validacion

### LoRA

- Archivo existente:
  - `models/loras/elena_voss_v1.safetensors`
- Integracion verificada por ComfyUI:
  - `LORA_VISIBLE=elena_voss_v1.safetensors`

### Dataset LoRA refinado

Resultado:

- Imagenes seleccionadas: 30.
- Distribucion: 6 por categoria.
- Archivos finales en `dataset_lora/images/`: 30 `.png` y 30 `.txt`.
- Caches viejos `.npz` eliminados antes de regenerar dataset.

Score del dataset refinado contra si mismo:

- Face: 39.25.
- Body: 10.54.
- Style: 44.74.
- Narrative: 100.00.
- Global: 40.57.
- ISI: 41.35.
- Status: `rejected`.

Conclusion:

- El dataset legacy no contiene una identidad suficientemente estable.

### Ultimo lote diario

Metadata:

- `docs/daily-elena-images-20260607-194019.json`

Resultado contra dataset LoRA:

- Face: 10.04.
- Body: 61.65.
- Style: 84.42.
- Narrative: 100.00.
- Global: 50.17.
- ISI: 46.10.
- Status: `rejected`.
- Approved: `false`.

Auto-audit del mismo lote:

- Face: 60.96.
- Body: 66.59.
- Style: 87.44.
- Narrative: 100.00.
- Global: 72.48.
- ISI: 70.74.
- Status: `rejected`.

Conclusion:

- La generacion actual puede acercarse a una misma direccion estetica, pero todavia no produce la misma mujer ni el mismo cuerpo con el nivel requerido.

### Dashboard

HTTP validado:

- URL: `http://127.0.0.1:8000`
- Status: 200.
- Contiene `Elena Voss`.
- Contiene `GENERAR CONTENIDO DE HOY`.
- Contiene `Identity Stability Index`.
- Contiene estado rechazado.

Laravel:

- `php artisan test --filter ExampleTest`: 2 tests passed.
- `php artisan route:list`: 8 rutas visibles.

### PostgreSQL

Ultimo registro en `consistency_batches`:

- `gate_status=rejected`
- `face_score=10.04`
- `body_score=61.65`
- `style_score=84.42`
- `narrative_score=100.00`
- `global_score=50.17`
- `isi_score=46.10`
- `approved=false`

## Errores y correcciones

- Se instalo inicialmente parte de Computer Vision en el venv de ComfyUI y PyTorch quedo CPU; se corrigio reinstalando PyTorch CUDA en `comfyui/.venv`.
- `mediapipe` no exponia `solutions` con la version inicial; se corrigio fijando version compatible en `quality/.venv`.
- Training LoRA fallo con OOM usando `--lowram`; se corrigio quitando ese modo para la RTX 4050.
- Training fallo por `shuffle_caption=true` con cache de text encoder; se corrigio a `shuffle_caption=false`.
- Training fallo por `persistent_workers` con workers 0; se elimino esa opcion.
- Smoke training genero NaN con fp8/full fp16; se corrigio usando fp16 estable sin fp8.
- Generacion diaria inicial salia solo en playa; se corrigio a lote balanceado con `--count-per-category 1`.
- Prompts legacy contenian `Valentina`; se corrigio personalizando variantes con el nombre del personaje activo.
- Style Score castigaba demasiado la diversidad normal entre categorias; se recalibro la escala de distancia.
- Body Score trataba landmarks faltantes como longitud cero; se corrigio usando dimensiones faltantes y comparacion por proporciones visibles.
- `768x1024` corrio en la RTX 4050 pero empeoro identidad; se descarto y se dejo `512x768`.

## Decision final de esta fase

El sistema funcional existe, pero Elena Voss no esta lista para produccion.

La produccion queda bloqueada hasta rehacer la base de identidad y reentrenar una LoRA que alcance:

- Face >= 90.
- Body >= 90.
- ISI >= 90.
- 100 imagenes consecutivas aprobadas.

