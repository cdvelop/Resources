## Instalación de PeaZip en Debian 12

1. Descarga el paquete .deb desde la página oficial,
   Verifica si hay una versión más reciente en
   https://peazip.github.io/peazip-linux.html

   ```bash
   wget https://github.com/peazip/PeaZip/releases/download/10.5.0/peazip_10.5.0.LINUX.GTK2-1_amd64.deb
    ```


2. Instala el paquete descargado:

   ```bash
   sudo apt install ./peazip_*_amd64.deb
   ```

3. Si hay dependencias faltantes, ejecuta:

   ```bash
   sudo apt --fix-broken install
   ```

4. PeaZip aparecerá en el menú de aplicaciones con interfaz gráfica.

Referencia: https://peazip.github.io/peazip-linux.html
https://peazip.github.io/peazip-linux.html

