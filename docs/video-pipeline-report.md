# Fase 8 - Pipeline De Video

Fecha: 2026-05-31

## 1. Objetivo

Crear un pipeline local para convertir imagenes generadas en videos cortos verticales con subtitulos usando FFmpeg.

Flujo requerido:

```text
Imagenes -> FFmpeg -> Video corto -> Subtitulos -> Exportacion
```

## 2. Archivos Creados

- `scripts/create_short_video.py`
- `videos/generated/valentina_sol_lifestyle_short.mp4`
- `videos/generated/valentina_sol_lifestyle_short.srt`
- `videos/generated/valentina_sol_lifestyle_concat.txt`
- `docs/video-pipeline-result.json`
- `docs/video-preview-frame.jpg`

## 3. Codigo Generado

Archivo: `scripts/create_short_video.py`

Funciones principales:

- Detecta `ffmpeg.exe` y `ffprobe.exe`.
- Lee `docs/dataset-valentina-sol.json`.
- Lee `docs/content-batch-valentina-sol.json`.
- Selecciona imagenes por categoria.
- Genera archivo concat para FFmpeg.
- Genera subtitulos `.srt`.
- Renderiza video vertical 1080x1920.
- Quema subtitulos usando filtro `subtitles`.
- Exporta MP4 H.264.
- Valida salida con `ffprobe`.
- Guarda resultado en `docs/video-pipeline-result.json`.

Configuracion usada:

- Categoria: `lifestyle`
- Imagenes: `6`
- Duracion por imagen: `2.5` segundos
- Duracion total: `15` segundos
- Resolucion: `1080x1920`
- FPS: `30`
- Codec: `h264`
- Formato pixel: `yuv420p`
- Audio: desactivado

## 4. Comandos Ejecutados

Verificacion inicial FFmpeg:

```powershell
ffmpeg -version
where.exe ffmpeg
ffmpeg -filters | Select-String -Pattern 'subtitles','drawtext'
```

Instalacion FFmpeg:

```powershell
winget install --id Gyan.FFmpeg -e --accept-source-agreements --accept-package-agreements --silent
```

Ubicacion real:

```text
C:\Users\magdi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe
```

Verificacion filtros:

```powershell
& 'C:\Users\magdi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe' -filters | Select-String -Pattern 'subtitles','drawtext'
```

Crear video:

```powershell
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" scripts\create_short_video.py
```

Validar MP4:

```powershell
& 'C:\Users\magdi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffprobe.exe' -v error -select_streams v:0 -show_entries stream=codec_name,width,height,r_frame_rate,duration -of default=noprint_wrappers=1 videos\generated\valentina_sol_lifestyle_short.mp4
```

Extraer frame QA:

```powershell
& 'C:\Users\magdi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe' -y -hide_banner -ss 6 -i videos\generated\valentina_sol_lifestyle_short.mp4 -frames:v 1 docs\video-preview-frame.jpg
```

## 5. Resultado Esperado

- FFmpeg instalado y verificable.
- Pipeline reproducible desde CLI.
- Video vertical corto generado desde imagenes del dataset.
- Subtitulos creados en SRT.
- Subtitulos quemados en el MP4 final.
- MP4 validado por `ffprobe`.
- Frame de QA generado.

## 6. Validacion

### FFmpeg

Resultado:

```text
ffmpeg version 8.1.1-full_build-www.gyan.dev
```

Filtros:

```text
ass
drawtext
subtitles
```

### Pipeline

Resultado:

```json
{
  "status": "ok",
  "output": "videos/generated/valentina_sol_lifestyle_short.mp4",
  "srt": "videos/generated/valentina_sol_lifestyle_short.srt",
  "image_count": 6
}
```

### MP4

Resultado:

```text
codec_name=h264
width=1080
height=1920
r_frame_rate=30/1
duration=15.000000
```

### Archivos

Resultado:

```text
videos/generated/valentina_sol_lifestyle_short.mp4 | 840634 bytes
videos/generated/valentina_sol_lifestyle_short.srt | 613 bytes
videos/generated/valentina_sol_lifestyle_concat.txt | 1382 bytes
docs/video-pipeline-result.json | 6280 bytes
docs/video-preview-frame.jpg | 63858 bytes
```

### Subtitulos

Resultado:

```text
1
00:00:00,000 --> 00:00:02,950
La vida que me gustaria
vivir

2
00:00:03,000 --> 00:00:05,950
Hoy me enfoque en lo que
realmente importa:...
```

### QA Visual

Archivo:

```text
docs/video-preview-frame.jpg
```

Revision:

- El video usa imagenes reales del dataset inicial.
- Los subtitulos estan quemados en el video.
- El texto ya no cubre toda la cara despues del ajuste de fuente y longitud.
- El archivo es apto como primer video automatizado de validacion.

## Errores Y Correcciones

### Error 1 - FFmpeg No Instalado

Sintoma:

```text
The term 'ffmpeg' is not recognized
```

Causa:

FFmpeg no estaba instalado ni disponible en PATH.

Correccion:

Se instalo `Gyan.FFmpeg` con winget.

### Error 2 - PATH No Refrescado

Sintoma:

Despues de instalar, `ffmpeg` seguia sin aparecer en el shell actual.

Causa:

WinGet modifico PATH, pero el shell necesitaba reinicio.

Correccion:

Se localizo el binario real y el pipeline usa ruta absoluta por defecto.

### Error 3 - Ejecucion Bloqueada Por Sandbox

Sintoma:

```text
Program 'ffmpeg.exe' failed to run ... Acceso denegado.
```

Causa:

El sandbox de solo lectura bloqueo ejecucion de binarios externos.

Correccion:

Se ejecuto FFmpeg con permisos elevados.

### Error 4 - Duracion Incorrecta

Sintoma:

```text
duration=17.433333
```

Causa:

El concat demuxer extendio el ultimo frame mas alla del target.

Correccion:

Se agrego `-t 15.000` al comando FFmpeg.

Resultado:

```text
duration=15.000000
```

### Error 5 - Subtitulos Demasiado Grandes

Sintoma:

Los subtitulos cubrian gran parte del rostro.

Causa:

La combinacion de texto largo y `FontSize=18` renderizaba demasiado grande en 1080x1920.

Correccion:

Se redujo el texto a frases cortas, se bajo `FontSize` a `6` y se ajusto el wrapping.

## Decision CTO

Fase 8 queda aprobada.

Existe un pipeline reproducible que toma imagenes y contenido editorial, crea SRT, renderiza MP4 vertical con subtitulos quemados y valida codec, duracion y resolucion con FFprobe.
