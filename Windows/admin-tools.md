# Herramientas Administrativas de Windows

A continuación se muestra una lista de accesos directos a herramientas administrativas en Windows:

- **Administración de equipos:**
    ```cmd
    %windir%\system32\compmgmt.msc /s
    ```

- **Administración de impresión:**
    ```bash
    %systemroot%\system32\printmanagement.msc
    ```

- **Configuración del sistema:**
    ```bash
    %windir%\system32\msconfig.exe
    ```

- **Diagnóstico de memoria de Windows:**
    ```bash
    %windir%\system32\MdSched.exe
    ```

- **Directivas de seguridad local:**
    ```bash
    %windir%\system32\secpol.msc /s
    ```

- **Firewall de Windows:**
    ```bash
    %windir%\system32\WF.msc
    ```

- **Iniciados iSCSI:**
    ```bash
    %windir%\system32\iscsicpl.exe
    ```

- **.NET Framework:**
    ```bash
    "C:\Program Files\Microsoft Visual Studio 8\SDK\v2.0\Bin\mscorcfg.msc"
    ```

- **Monitor de rendimiento:**
    ```bash
    %windir%\system32\perfmon.msc /s
    ```

- **Orígenes de datos:**
    ```bash
    %windir%\system32\odbcad32.exe
    ```

- **Programador de tareas:**
    ```bash
    %windir%\system32\taskschd.msc /s
    ```

- **Servicios de componentes:**
    ```bash
    %windir%\system32\comexp.msc
    ```

- **Servicios:**
    ```bash
    %windir%\system32\services.msc
    ```

- **Visor de eventos:**
    ```bash
    %windir%\system32\eventvwr.msc /s
    ```

- **Windows PowerShell Modules:**
    ```bash
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -ImportSystemModules
    ```