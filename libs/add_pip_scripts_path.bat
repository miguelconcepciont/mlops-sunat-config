@echo off
setlocal

REM Ruta al directorio de scripts de Python 3.13 (ajústalo si tu versión es distinta)
set "PIP_SCRIPTS=%LOCALAPPDATA%\Packages\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\LocalCache\local-packages\Python313\Scripts"

REM Agrega al PATH del usuario si no existe
echo Verificando si el PATH ya contiene la ruta...
echo %PATH% | find /I "%PIP_SCRIPTS%" >nul
if errorlevel 1 (
    echo Agregando al PATH de usuario...
    setx PATH "%PATH%;%PIP_SCRIPTS%" /M
    echo ✅ Ruta agregada correctamente. Reinicia la consola para que surta efecto.
) else (
    echo ⚠️ La ruta ya existe en el PATH.
)

endlocal
pause
