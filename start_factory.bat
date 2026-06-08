@echo off
echo ==========================================
echo  FABRICA DE CONTENIDO ELENA VOSS
echo ==========================================
echo.
echo 1. Iniciar Fabrica (Modo Standard)
echo 2. Iniciar Validacion de Identidad (Identity Rebuild)
echo.
set /p mode="Selecciona un modo (1/2): "

if "%mode%"=="2" goto validation
goto standard

:validation
echo Iniciando Reconstruccion de Identidad...
pwsh -NoProfile -ExecutionPolicy Bypass -File "scripts\run_identity_validation.ps1"
pause
goto end

:standard
echo Iniciando Fabrica Standard...
if not exist ".\output\images" mkdir ".\output\images"
if not exist ".\output\videos" mkdir ".\output\videos"
start /min cmd /c "cd backend && php artisan serve"
echo Panel disponible en http://localhost:8000
echo Presiona Enter para iniciar el Worker de ComfyUI (Asegurate de no estar corriendo Ollama)
pause
call .\comfyui\.venv\Scripts\activate.bat
python .\comfyui\ComfyUI\main.py --listen 127.0.0.1 --port 8188 --disable-auto-launch --lowvram --xformers --output-directory .\output\images

:end
