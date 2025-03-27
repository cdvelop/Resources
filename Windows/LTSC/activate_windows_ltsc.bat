@echo off
echo Script para activar Windows 10 LTSC 2021
echo.

echo Paso 1: Copiando contenido de SKUS.zip a la carpeta de tokens...
echo Necesita descargar el fichero SKUS.zip del repositorio github.com/cdvelop/Notes/Windows/LTSC/SKUS.zip y colocarlo en el mismo directorio que este script.
pause
if not exist SKUS.zip (
    echo Error: No se encontro el archivo SKUS.zip. Por favor, descarguelo y coloque en este directorio.
    pause
    exit /b
)
echo Extrayendo SKUS.zip...
powershell -Command "Expand-Archive -Path 'SKUS.zip' -DestinationPath 'C:\Windows\System32\spp\tokens\skus' -Force"

echo.
echo Paso 2: Reiniciando el PC...
echo Por favor, reinicie el PC manualmente.
pause

echo.
echo Paso 3: Ejecutando comandos CMD como administrador...
cscript.exe %windir%\system32\slmgr.vbs /rilc
cscript.exe %windir%\system32\slmgr.vbs /upk >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ckms >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /cpky >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
clipup -v -o -altto c:\
echo.

echo Paso 4: Ejecutando comando PowerShell como administrador...
powershell -Command "irm https://get.activated.win | iex"

echo.
echo Proceso completado.
pause
    echo Error downloading SKUS.zip to temporary directory. Please check your internet connection and try again. >> log.txt 2>&1
    echo Error downloading SKUS.zip to temporary directory. Please check your internet connection and try again.
    echo Error en el paso 1 >> log.txt 2>&1
    goto :error_step1
)
echo. >> log.txt 2>&1
echo SKUS.zip downloaded successfully to temporary directory. >> log.txt 2>&1

echo. >> log.txt 2>&1
echo Verifying SKUS.zip download in temporary directory... >> log.txt 2>&1
for /f "tokens=5" %%a in ('dir /b "%TEMP%\SKUS.zip"') do set ZIP_SIZE=%%a >> log.txt 2>&1
echo File size of SKUS.zip: %ZIP_SIZE% bytes >> log.txt 2>&1
if %ZIP_SIZE% EQU 0 (
    echo Error: Downloaded SKUS.zip is empty. Retrying download... >> log.txt 2>&1
    echo Error: Downloaded SKUS.zip is empty. Retrying download...
    echo Error en el paso 1 >> log.txt 2>&1
    goto :error_step1
)

echo. >> log.txt 2>&1
echo Extracting SKUS.zip to C:\Windows\System32\spp\tokens\skus... >> log.txt 2>&1
powershell -Command "Expand-Archive -Path '%TEMP%\SKUS.zip' -Destination 'C:\Windows\System32\spp\tokens\skus' -Force" >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error extracting SKUS.zip. The zip file might be corrupted. >> log.txt 2>&1
    echo Please ensure you have administrator rights and the destination folder exists. >> log.txt 2>&1
    echo Error extracting SKUS.zip. The zip file might be corrupted or administrator rights are missing.
    echo Error en el paso 1 >> log.txt 2>&1
    goto :error_step1
)
echo. >> log.txt 2>&1
echo SKUS.zip extracted successfully. >> log.txt 2>&1
echo Paso 1 completado exitosamente >> log.txt 2>&1
goto :extract_success

:error_step1
echo Error en el paso 1. Revision de logs >> log.txt 2>&1
echo Error en el paso 1. Revision de logs
goto :log_error

:download_retry
echo. >> log.txt 2>&1
echo Retrying SKUS.zip download... >> log.txt 2>&1
timeout /t 5 /nobreak >nul >> log.txt 2>&1
curl -L -o "%TEMP%\SKUS.zip" https://github.com/cdvelop/Notes/raw/main/Windows/LTSC/SKUS.zip >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error downloading SKUS.zip again. Please check your internet connection and the download URL. >> log.txt 2>&1
    echo Error downloading SKUS.zip again. Please check your internet connection and the download URL.
    echo Error en el paso 1 >> log.txt 2>&1
    goto :error_step1
)
echo. >> log.txt 2>&1
echo SKUS.zip downloaded successfully on retry. >> log.txt 2>&1
echo Paso 1 completado exitosamente >> log.txt 2>&1
goto :step1_verify_zip

:extract_success
echo Extraction successful, continuing to next step. >> log.txt 2>&1


goto :cleanup_temp_zip

:cleanup_temp_zip
echo Cleaning up temporary SKUS.zip file... >> log.txt 2>&1
del "%TEMP%\SKUS.zip" >> log.txt 2>&1
if %errorlevel% equ 0 (
    echo Temporary SKUS.zip file removed. >> log.txt 2>&1
) else (
    echo Warning: Failed to delete temporary SKUS.zip file. >> log.txt 2>&1
)
echo Limpieza de archivos temporales completada >> log.txt 2>&1
rem call :setState 1
goto :step2

:step2
echo. >> log.txt 2>&1
echo ## Step 2: reiniciar el pc >> log.txt 2>&1
echo. >> log.txt 2>&1
echo Please restart your PC now. >> log.txt 2>&1
echo Reiniciando el PC... >> log.txt 2>&1
shutdown /r /t 0
exit /b

:step3
echo. >> log.txt 2>&1
echo ## Step 3: luego de reiniciar ejecutar en cmd los comando como administrador >> log.txt 2>&1
echo. >> log.txt 2>&1
echo Running CMD commands... >> log.txt 2>&1
cscript.exe %windir%\system32\slmgr.vbs /rilc >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando cscript.exe %windir%\system32\slmgr.vbs /rilc >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo cscript.exe %windir%\system32\slmgr.vbs /rilc completed. >> log.txt 2>&1
cscript.exe %windir%\system32\slmgr.vbs /upk >nul 2>&1 >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando cscript.exe %windir%\system32\slmgr.vbs /upk >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo cscript.exe %windir%\system32\slmgr.vbs /upk completed. >> log.txt 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ckms >nul 2>&1 >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando cscript.exe %windir%\system32\slmgr.vbs /ckms >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo cscript.exe %windir%\system32\slmgr.vbs /ckms completed. >> log.txt 2>&1
cscript.exe %windir%\system32\slmgr.vbs /cpky >nul 2>&1 >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando cscript.exe %windir%\system32\slmgr.vbs /cpky >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo cscript.exe %windir%\system32\slmgr.vbs /cpky completed. >> log.txt 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D completed. >> log.txt 2>&1
sc config LicenseManager start= auto & net start LicenseManager >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando sc config LicenseManager >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo sc config LicenseManager completed. >> log.txt 2>&1
sc config wuauserv start= auto & net start wuauserv >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando sc config wuauserv >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo sc config wuauserv completed. >> log.txt 2>&1
clipup -v -o -altto c:\ >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando clipup -v -o -altto c:\ >> log.txt 2>&1
    echo Error en el paso 3 >> log.txt 2>&1
    goto :error_step3
)
echo clipup -v -o -altto c:\ completed. >> log.txt 2>&1
echo. >> log.txt 2>&1
echo Paso 3 completado exitosamente >> log.txt 2>&1
rem call :setState 3
goto :step4

:error_step3
echo Error en el paso 3. Revision de logs >> log.txt 2>&1
echo Error en el paso 3. Revision de logs
goto :log_error


:step4
echo. >> log.txt 2>&1
echo ## Step 4: ejecutar en powerShell como administrador >> log.txt 2>&1
echo. >> log.txt 2>&1
echo Running PowerShell command... >> log.txt 2>&1
powershell -Command "irm https://get.activated.win | iex" >> log.txt 2>&1
if %errorlevel% neq 0 (
    echo Error en comando powershell -Command "irm https://get.activated.win | iex" >> log.txt 2>&1
    echo Error en el paso 4 >> log.txt 2>&1
    goto :error_step4
)
echo powershell -Command "irm https://get.activated.win | iex" completed. >> log.txt 2>&1
echo Paso 4 completado exitosamente >> log.txt 2>&1
rem call :setState 4
goto :step5

:error_step4
echo Error en el paso 4. Revision de logs >> log.txt 2>&1
echo Error en el paso 4. Revision de logs
goto :log_error

:step5
echo. >> log.txt 2>&1
echo # Proceso finalizado >> log.txt 2>&1
echo Windows 10 LTSC activation process completed. >> log.txt 2>&1
echo. >> log.txt 2>&1
echo Reiniciando el PC en 5 segundos... >> log.txt 2>&1
timeout /t 5 /nobreak >nul >> log.txt 2>&1
shutdown /r /t 0
exit /b

:log_error
echo. >> log.txt 2>&1
echo # Proceso finalizado con errores. Ver log.txt para detalles >> log.txt 2>&1
echo # Proceso finalizado con errores. Ver log.txt para detalles
echo. >> log.txt 2>&1
date /t >> log.txt 2>&1
time /t >> log.txt 2>&1
exit /b

:final_step
echo. >> log.txt 2>&1
echo # Proceso finalizado >> log.txt 2>&1
echo Windows 10 LTSC activation process completed successfully. >> log.txt 2>&1
echo. >> log.txt 2>&1
date /t >> log.txt 2>&1
time /t >> log.txt 2>&1
echo Script finalizado correctamente. Ver log.txt para detalles >> log.txt 2>&1
exit /b
