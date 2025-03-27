# Solucion Windows 10 LTSC se apaga cada 1 hora si no se activa
El S.O. Es Una Version De Prueba/Evaluacion Por Lo Cual Es Muy Importante 
Introducir Todos Estos Comandos Para Que El Sistema Operativo Este Estable Y 
Funcional Para Su Correcto Funcionamiento.


## 1 copiar todo el contenido del zip SKUS.zip a la carpeta de:
C:\Windows\System32\spp\tokens\skus

## 2 reiniciar el pc

## 3 luego de reiniciar ejecutar en cmd los comando como administrador
```bash
cscript.exe %windir%\system32\slmgr.vbs /rilc
cscript.exe %windir%\system32\slmgr.vbs /upk >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ckms >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /cpky >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
clipup -v -o -altto c:\
echo
```

## 4 ejecutar en powerShell como administrador
```shell
irm https://get.activated.win | iex
```
video: https://youtu.be/ZpyupIbkgG0?si=qLufBkHIa40gn0xX

## Comando para ejecutar el script de activación de Windows 10 LTSC 2021

Para ejecutar el script de activación de Windows 10 LTSC 2021, copie y pegue el siguiente comando en el símbolo del sistema (CMD) como administrador y presione Enter:

```cmd
@powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/cdvelop/Notes/main/Windows/LTSC/activate_windows_ltsc.bat' -OutFile '%TEMP%/activate_windows_ltsc.bat'; Start-Process -FilePath '%TEMP%/activate_windows_ltsc.bat' -Verb RunAs"
```

**Explicación del comando:**

*   `@powershell -NoProfile -ExecutionPolicy Bypass -Command`:  Invoca PowerShell en modo "NoProfile" (sin cargar el perfil del usuario) y con la política de ejecución "Bypass" para permitir la ejecución de scripts sin firmar.
*   `Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/cdvelop/Notes/main/Windows/LTSC/activate_windows_ltsc.bat' -OutFile '%TEMP%/activate_windows_ltsc.bat'`: Descarga el script `activate_windows_ltsc.bat` desde la URL especificada en el repositorio de GitHub y lo guarda en la carpeta temporal (`%TEMP%`) del sistema.
*   `;`:  Separador de comandos en PowerShell.
*   `Start-Process -FilePath '%TEMP%/activate_windows_ltsc.bat' -Verb RunAs`: Ejecuta el script descargado (`activate_windows_ltsc.bat`) que se encuentra en la carpeta temporal con permisos de administrador (`-Verb RunAs`).

**Prerrequisitos:**

*   **Conexión a Internet:**  Es necesario tener conexión a Internet para descargar el script desde GitHub.
*   **Ejecutar CMD como administrador:**  El símbolo del sistema (CMD) debe ejecutarse con privilegios de administrador para que el script se ejecute correctamente.

**Instrucciones para ejecutar el script de activación (activate_windows_ltsc.bat):**

1.  **Descargue el script:**
    *   Abra un navegador web y vaya a la siguiente URL:
        `https://raw.githubusercontent.com/cdvelop/Notes/main/Windows/LTSC/activate_windows_ltsc.bat`
    *   Haga clic derecho en la página y seleccione "Guardar como...".
    *   Guarde el archivo como `activate_windows_ltsc.bat` en el mismo directorio donde se encuentra el archivo `windows-10-se-apaga-automaticamente.md`.
    *   Alternativamente, puede usar PowerShell para descargar el script:
        ```powershell
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/cdvelop/Notes/main/Windows/LTSC/activate_windows_ltsc.bat' -OutFile 'activate_windows_ltsc.bat'
        ```
2.  **Descargue el archivo SKUS.zip:**
    *   Descargue el archivo `SKUS.zip` desde el repositorio:
        `https://github.com/cdvelop/Notes/blob/main/Windows/LTSC/SKUS.zip`
    *   Coloque el archivo `SKUS.zip` en el mismo directorio donde guardó `activate_windows_ltsc.bat`.
3.  **Ejecute el script:**
    *   Abra el **Símbolo del sistema (CMD)** como administrador.
    *   Navegue hasta el directorio donde guardó los archivos `activate_windows_ltsc.bat` y `SKUS.zip` usando el comando `cd`.
    *   Ejecute el script `activate_windows_ltsc.bat` escribiendo el nombre del script y presionando Enter:
        ```cmd
        activate_windows_ltsc.bat
        ```
4.  **Siga las instrucciones en pantalla:** El script le guiará a través del proceso de activación. Reinicie el equipo cuando se le indique.
