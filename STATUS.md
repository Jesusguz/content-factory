# STATUS - Elena Voss Content Factory

Fecha local de ejecucion: 2026-06-07
Fecha UTC de evidencias: 2026-06-08

## Mandato Activo

El proyecto queda bloqueado por consistencia hasta lograr:

- LoRA `models/loras/elena_voss_v1.safetensors` existente e integrada.
- Face Consistency >= 90.
- Body Consistency >= 90.
- Style Consistency >= 85.
- Narrative Consistency >= 85.
- Global Consistency Score >= 90.
- Identity Stability Index (ISI) >= 90.
- 100 imagenes consecutivas aprobadas con identidad estable.
- Dashboard con boton `[GENERAR CONTENIDO DE HOY]`.

Mientras ISI < 90:

- No publicar.
- No aprobar lotes.
- No incluir contenido nuevo en calendario.
- No crear produccion masiva.

## Estado Actual

BLOQUEADO para produccion.

Ultimo lote diario verificado:

- Status: `rejected`.
- Approved: `false`.
- Imagenes generadas: 5.
- Face Consistency: 10.04.
- Body Consistency: 61.65.
- Style Consistency: 84.42.
- Narrative Consistency: 100.00.
- Global Consistency Score: 50.17.
- Identity Stability Index (ISI): 46.10.

Motivo principal:

- La LoRA existe e integra, pero no aprendio una identidad facial estable desde el dataset legacy.
- El dataset refinado sigue siendo inconsistente: Face 39.25, Body 10.54, ISI 41.35 cuando se mide contra si mismo.
- El mejor auto-audit del lote diario llego a ISI 70.74, todavia debajo de 90.

## COMPLETO

- Auditoria del proyecto existente.
- `identity_bible.json` como fuente unica de verdad para Elena Voss.
- Dataset LoRA inicial curado en `dataset_lora/` con 30 imagenes y captions de identidad.
- Selector de dataset con filtro de calidad, pose y cluster facial:
  - `scripts/select_lora_dataset.py`.
- LoRA entrenada y existente:
  - `models/loras/elena_voss_v1.safetensors`.
- Integracion obligatoria de LoRA en generacion ComfyUI:
  - `scripts/generate_valentina_dataset.py`.
- Generacion diaria con LoRA obligatoria y lote balanceado:
  - `scripts/generate_today.ps1`.
- Consistency Score implementado:
  - Face.
  - Body.
  - Style.
  - Narrative.
  - Global.
  - ISI.
- Resultados persistidos en PostgreSQL:
  - `consistency_batches`.
  - `consistency_items`.
- Dashboard Laravel actualizado:
  - Boton `GENERAR CONTENIDO DE HOY`.
  - Consistency Score.
  - Identity Stability Index (ISI).
  - Bloqueo visual de aprobacion/publicacion.
- n8n image workflow conectado al gate diario:
  - `scripts/n8n_generate_images.ps1`.
- Programacion/publicacion bloqueada si el lote no aprueba:
  - `scripts/n8n_schedule_publication.ps1`.

## PARCIAL

- LoRA v1:
  - Existe.
  - Esta integrada.
  - No cumple Face >= 90 ni ISI >= 90.
- Dataset LoRA:
  - Cumple cantidad minima de 30 imagenes.
  - No cumple estabilidad facial/corporal suficiente.
- Generacion diaria:
  - Funciona.
  - Usa LoRA.
  - Genera 5 categorias balanceadas.
  - Rechaza automaticamente por score.
- Dashboard:
  - Visible y funcional por HTTP 200.
  - Muestra boton y scores.
  - No puede aprobar contenido con ISI < 90.
- Video:
  - Pipeline legacy existe.
  - No esta aprobado para produccion de Elena porque la identidad visual aun no es estable.

## BLOQUEADO

- Produccion masiva.
- Publicacion automatica.
- Calendario de contenido aprobado.
- Validacion de 100 imagenes consecutivas.

Bloqueo activo:

- `ISI < 90`.
- `Face < 90`.
- `Body < 90`.

## Decision Tecnica

No se debe seguir escalando contenido con la LoRA actual.

Siguiente trabajo permitido:

- Rehacer la base de identidad con un dataset semilla realmente consistente.
- Reentrenar `elena_voss_v1.safetensors` usando solo identidad estable.
- Volver a medir contra el gate.
- Avanzar solo cuando ISI >= 90.

