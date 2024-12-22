# Limpiar todos los recursos temporales de Docker
## Opciones comunes en los comandos Docker:
 -a: All - Elimina todos los recursos, no solo los que no están en uso
 -f: Force - Fuerza la eliminación sin solicitar confirmación


## Eliminar contenedores detenidos
docker container prune -f

## Eliminar imágenes sin usar
docker image prune -a -f

## Eliminar volúmenes sin usar
docker volume prune -f

## Eliminar redes sin usar
docker network prune -f

## Eliminar caché de construcción
docker builder prune -a -f

## Eliminar todo lo no utilizado (contenedores, imágenes, volúmenes y redes)
docker system prune -a -f

# Nota: El uso de la opción -f fuerza la eliminación sin solicitar confirmación.
# Tenga precaución al ejecutar estos comandos en un entorno de producción.


## Un solo comando para limpieza completa de Docker
docker system prune -a -f --volumes

# Este comando elimina:
# - Todos los contenedores detenidos
# - Todas las redes no utilizadas por al menos un contenedor
# - Todas las imágenes sin al menos un contenedor asociado
# - Toda la caché de construcción
# - Todos los volúmenes no utilizados

# Nota: Utilice este comando con precaución, ya que eliminará todos los recursos de Docker no utilizados sin solicitar confirmación.
