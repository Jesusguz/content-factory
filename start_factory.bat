@echo off
echo Iniciando Fábrica de Contenido Elena Voss...
if not exist ".\output\images" mkdir ".\output\images"
if not exist ".\output\videos" mkdir ".\output\videos"
start /min cmd /c "cd backend && php artisan serve"
echo Panel disponible en http://localhost:8000 - Presiona Enter para iniciar el Worker de ComfyUI (Asegurate de no estar corriendo Ollama al mismo tiempo)
pause
call .\comfyui\.venv\Scripts\activate.bat
python worker.py --lowvram --xformers
