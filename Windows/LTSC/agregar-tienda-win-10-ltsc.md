<!-- filepath: c:\Users\Cesar\Notes\Windows\LTSC\agregar-tienda-win-10-ltsc.md -->
# Agregar Microsoft Store a Windows 10 Enterprise LTSC

**Versión de Windows compatible:** Windows 10 Enterprise LTSC 2019

## 1. Descarga de Archivos Necesarios

Para comenzar, descarga los archivos de instalación desde el siguiente enlace:
[Descargar LTSC-Add-MicrosoftStore (ZIP)](https://github.com/lixuy/LTSC-Add-MicrosoftStore/archive/2019.zip)

## 2. Proceso de Instalación

1.  Una vez descargado el archivo `.zip`, extráelo en una carpeta de tu elección.
2.  Dentro de la carpeta extraída, haz clic derecho sobre el archivo `Add-Store.cmd` y selecciona **"Ejecutar como administrador"**.

    *   **Componentes Opcionales:**
        Si no deseas instalar `App Installer`, `Purchase App` o `Xbox identity`, puedes eliminar los archivos `.appxbundle` correspondientes a cada uno de estos componentes *antes* de ejecutar `Add-Store.cmd`.
        *Advertencia:* Si planeas instalar juegos o cualquier aplicación que ofrezca compras dentro de la aplicación, es recomendable **no eliminar** estos componentes e instalar todo el paquete.

## 3. Solución de Problemas Comunes Post-Instalación

Si la Microsoft Store no funciona correctamente después de la instalación inicial:

1.  **Reinicia tu computadora.** A menudo, un simple reinicio puede resolver el problema.
2.  **Si el reinicio no ayuda, registra nuevamente la aplicación de la Store:**
    *   Abre el **Símbolo del sistema (CMD)** o **Windows PowerShell** con privilegios de administrador.
        *   Para ello, busca "cmd" o "powershell" en el menú Inicio, haz clic derecho sobre el resultado y selecciona "Ejecutar como administrador".
    *   Copia y pega el siguiente comando en la terminal y presiona Enter:
        ```powershell
        PowerShell -ExecutionPolicy Unrestricted -Command "& {$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' ; Add-AppxPackage -DisableDevelopmentMode -Register $manifest}"
        ```
    *   Una vez que el comando se haya ejecutado, **reinicia tu computadora** nuevamente.

## 4. Limpiar la Caché de Microsoft Store (WSReset)

Si los pasos anteriores no resuelven el problema, intenta limpiar la caché de la Microsoft Store:

1.  Presiona las teclas `Win + R` para abrir el cuadro de diálogo "Ejecutar".
2.  Escribe `WSReset.exe` y haz clic en "Aceptar" o presiona Enter.
    *   Se abrirá una ventana del símbolo del sistema que se cerrará automáticamente una vez que la caché se haya limpiado. La Microsoft Store debería abrirse después de este proceso.

---

## si aparece el error microsoft store no esta disponible en tu pais o region
- ve a Selecciona Inicio  > Configuración  > Hora e idioma > Región. y cambia a Estados Unidos

vuelve a iniciar


<small>Este método se basa en el trabajo y las contribuciones de la comunidad. El script original `Add-Store.cmd` y la solución general fueron popularizados por discusiones en foros como My Digital Life, con contribuciones de usuarios como abbodi1406.</small>
<small>Fuente original de la discusión y script (por abbodi1406): [My Digital Life Forums](https://forums.mydigitallife.net/threads/add-store-to-windows-10-enterprise-ltsc-LTSC.70741/page-30#post-1468779)</small>
