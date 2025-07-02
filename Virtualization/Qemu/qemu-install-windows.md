# Instalación QEMU en Windows

1. Descarga el instalador de QEMU desde el sitio web oficial: https://www.qemu.org/download/
![image](img/qemu-download-01.JPG) 
![image](img/qemu-download-02.JPG)

2. Ejecuta el instalador y sigue las instrucciones.
3. Agrega el directorio de instalación "C:\Program Files\qemu" a la variable de entorno PATH usuario actual.
![image](img/env-vars.JPG)

4. Desactiva Hyper-V en el panel de control de aplicaciones para evitar problemas de compatibilidad.
![image](img/hyper-v-off.JPG) reinicia el equipo.

5. verifica en tu consola favorita la versión de QEMU instalada: 
```bash
qemu-system-x86_64.exe --version
```
![image](img/qemu-version.JPG)

6. necesitamos descargar el acelerador gráfico intel para QEMU desde https://github.com/intel/haxm
![image](img/qemu-haxm.JPG)
![image](img/qemu-haxm-zip.JPG)

7. descomprima y ejecute como administrador
![image](img/qemu-haxm-run.JPG). instale 

si durante la instalacion aparece este mensaje de advertencia
![image](img/qemu-haxm-info.JPG)

8. verifique si el servicio esta en ejecución
con el comando 
```bash
sc query intelhaxm
```
![image](img/qemu-haxm-ok.JPG)





