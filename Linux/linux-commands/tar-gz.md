# pasos para descomprimir un archivo tar.gz en linux
1. Navegar al directorio donde se encuentra el archivo .tar.gz:
   
   cd /ruta/al/directorio
   

2. Descomprimir el archivo usando el comando tar:
   
   tar -xzvf nombre_del_archivo.tar.gz
   

   Donde:
   - x: extrae archivos del archivo comprimido
   - z: descomprime el archivo gzip
   - v: muestra el progreso de la extracción (verbose)
   - f: especifica el nombre del archivo a descomprimir

3. Verificar los archivos extraídos:
   
   ls -l
   

Nota: Si deseas extraer el contenido en un directorio específico, puedes usar la opción -C:

tar -xzvf nombre_del_archivo.tar.gz -C /ruta/del/directorio/destino


