# donde office excel almacena temporarmente el guardado automatico del archivo,,ya que aveces el usario no guardo y quisiera recuperar informacion. es posible?

Cuando trabajas con **Microsoft Excel**, incluso si el usuario no guardó manualmente el archivo, existen mecanismos de **recuperación automática**. Todo depende de cómo esté configurado el **Autoguardado (AutoSave / AutoRecover)** en la instalación de Office:

---

### 🔹 Dónde guarda Excel los archivos temporales

Excel almacena archivos de recuperación en carpetas temporales especiales del sistema, por ejemplo:

* **Windows (Excel moderno, Office 365/2019/2016)**

  ```
  C:\Users\<usuario>\AppData\Local\Microsoft\Office\UnsavedFiles\
  ```
* **Windows (archivos temporales mientras está abierto)**

  ```
  C:\Users\<usuario>\AppData\Local\Temp\
  ```
* **MacOS**

  ```
  /Users/<usuario>/Library/Containers/com.microsoft.Excel/Data/Library/Preferences/AutoRecovery/
  ```

---

### 🔹 Funciones de recuperación

1. **AutoRecover**: guarda copias de seguridad periódicas (por defecto cada 10 min).

   * Si Excel se cierra inesperadamente, al volver a abrirlo muestra el **Panel de Recuperación de Documentos** con los archivos encontrados.
   * Estos archivos tienen extensión `.xlsb` o `.xar` en las carpetas mencionadas.

2. **Versiones anteriores (OneDrive/SharePoint)**: si el archivo estaba en la nube y con AutoSave activado, puedes recuperar versiones desde **Archivo > Información > Historial de versiones**.

3. **Archivos temporales (.tmp o ~archivo.xlsx)**: si Excel no alcanzó a guardar AutoRecover, a veces queda un temporal en la carpeta Temp del sistema. Renombrándolo a `.xlsx` puede abrirse.

---

### 🔹 Cómo intentar recuperar

* Abre Excel → **Archivo > Abrir > Recuperar libros no guardados** (te lleva directo a `UnsavedFiles`).
* Busca en la carpeta `Temp` los archivos recientes con nombres tipo `~Excel...tmp`.
* Si el archivo existía antes, clic derecho en el explorador de Windows → **Restaurar versiones anteriores**.

---

👉 Entonces, sí: **Excel guarda temporalmente el archivo automáticamente y muchas veces se puede recuperar** desde esas rutas o desde el mismo programa.

Perfecto 👌 te paso un **script en batch (CMD)** que busca los archivos de recuperación automática de Excel en Windows y los lista para que puedas abrirlos.

Estos archivos suelen estar en la carpeta `UnsavedFiles` o en `Temp`.

---

## 📜 Script en Batch (`buscar_excel_autoguardados.bat`)

```bat
@echo off
echo =============================================
echo 🔎 Buscando archivos de Excel no guardados...
echo =============================================

REM Carpeta principal de autoguardado
set "unsaved=%USERPROFILE%\AppData\Local\Microsoft\Office\UnsavedFiles"
set "tempdir=%TEMP%"

echo.
echo 📂 Revisando carpeta de archivos no guardados:
if exist "%unsaved%" (
    dir "%unsaved%\*.xls*" /b /o:-d
) else (
    echo ❌ No existe la carpeta de UnsavedFiles.
)

echo.
echo 📂 Revisando carpeta temporal:
if exist "%tempdir%" (
    dir "%tempdir%\~*.xls*" /b /o:-d
    dir "%tempdir%\*.tmp" /b /o:-d | findstr /i "excel"
) else (
    echo ❌ No existe la carpeta Temp.
)

echo.
echo =============================================
echo ✅ Revisión finalizada
echo Abre manualmente los archivos listados en Excel.
echo Si es .tmp prueba renombrarlo a .xlsx
echo =============================================

pause
```

---

### 🔹 Cómo usarlo

1. Abre **Bloc de notas**.
2. Copia el código arriba y guarda el archivo como:

   ```
   buscar_excel_autoguardados.bat
   ```

   (elige **Todos los archivos** en tipo y no `.txt`).
3. Haz doble clic en el `.bat` → te mostrará los archivos encontrados.

* Los archivos `.xlsb`, `.xar` o `.xlsx` se pueden abrir directo en Excel.
* Los `.tmp` hay que **renombrarlos** a `.xlsx` para intentar abrirlos.

---


