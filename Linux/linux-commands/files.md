# crear directorio en linux
mkdir <nombre_directorio>

# crear directorio con subdirectorios en linux
mkdir -p folder1/subfolder

# Explicación:
# -p: crea los directorios padres si no existen
# Este comando creará el directorio "folder1" si no existe, y luego creará "subfolder" dentro de "folder1"



# Para eliminar un directorio o archivo en Linux permanentemente, usa los comandos rmdir o rm seguido del nombre del archivo para eliminar directamente.
Usa el comando rmdir o rm -d para eliminar directorios vacíos.
Usa el comando rm -r para eliminar directorios no vacíos.

# Para eliminar un directorio con archivos protegidos, usa el comando rm con las opciones -rf:
rm -rf nombre_del_directorio

# Explicación:
# -r: elimina recursivamente el contenido del directorio
# -f: fuerza la eliminación sin pedir confirmación, ignorando archivos no existentes y suprimiendo la mayoría de los mensajes de error

# ADVERTENCIA: Usa este comando con precaución, ya que eliminará permanentemente el directorio y todo su contenido sin posibilidad de recuperación.
