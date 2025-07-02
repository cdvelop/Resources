
## crear un contenedor en base a la imagen descargada
- ej: `docker create mongo` (mongo db tiene menos configuraciones para este ejemplo) 

## ejecutar contenedor
 `docker start <IMAGE_ID>` 
`Status: Downloaded newer image for mongo:latest
4f2b38bcc66de39ae5bd225734d297bd0fdda7bec847c6ab8db0d49ae84d3a02`
- ej: `docker start 4f2b38bcc66d` (no es necesario todo el id del container creado)

## verificar si el contenedor esta corriendo
`docker ps` al agregar *-a* mostrara todos los contenedores creados
- ej: `docker ps -a`

## detener contenedor
`docker stop <IMAGE_ID>` ej: `docker stop 4f2b38bcc66d`

## detener todos los contenedores
`docker stop $(docker ps -q)`

- Este comando detiene todos los contenedores en ejecución.
- La opción `-q` en `docker ps -q` devuelve solo los IDs de los contenedores en ejecución.
- Si algunos contenedores no responden, puedes agregar la opción `-t` para especificar un tiempo de espera antes de forzar la detención:
  `docker stop -t 10 $(docker ps -q)`


## eliminar un contenedor creado por su nombre
`docker rm <CONTAINER_NAME>` ej: `docker rm ecstatic_vaughan`

## eliminar todos los contenedores
`docker rm $(docker ps -aq)`

- Este comando elimina todos los contenedores, incluso los que están detenidos.
- La opción `-q` en `docker ps -aq` devuelve solo los IDs de los contenedores.
- Si algunos contenedores están en ejecución, puedes agregar la opción `-f` (force) para forzar la eliminación:
  `docker rm -f $(docker ps -aq)`

## detener y eliminar todos los contenedores en un solo comando
`docker stop $(docker ps -q) && docker rm $(docker ps -aq)`

- Este comando combina las operaciones de detener y eliminar todos los contenedores.
- Primero detiene todos los contenedores en ejecución con `docker stop $(docker ps -q)`.
- Luego elimina todos los contenedores (incluyendo los detenidos) con `docker rm $(docker ps -aq)`.
- Si algunos contenedores no responden o necesitas forzar la eliminación, puedes usar:
  `docker stop $(docker ps -q) && docker rm -f $(docker ps -aq)`


## asignar nombre a un contenedor cuando se crea
`docker create --name <CONTAINER_NAME> <FROM_IMAGE_NAME>`
-ej: `docker create --name monguito mongo `

## ver cuanta memoria consume un contenedor
`docker stats <CONTAINER_NAME>`
- ej: `docker stats monguito`

- Este comando muestra estadísticas en tiempo real del uso de recursos del contenedor, incluyendo el uso de memoria.
- Para ver solo el uso de memoria sin actualización en tiempo real, puedes usar:
  `docker stats --no-stream --format "{{.MemUsage}}" <CONTAINER_NAME>`

- Para obtener un resumen más detallado del uso de memoria:
  `docker inspect -f '{{.State.MemoryStats}}' <CONTAINER_NAME>`


## ver si el contenedor se ejecuto de forma correcta (logs)
`docker logs <CONTAINER_NAME>`
- ej: `docker logs monguito` (queda en espera la consola)

## quedar en escucha de los logs del contenedor (follow)
`docker logs -f <CONTAINER_NAME>` (mostrara en tiempo real)

## eliminar todos los contenedores
`docker rm $(docker ps -aq)`

- Este comando elimina todos los contenedores, incluso los que están detenidos.
- La opción `-q` en `docker ps -aq` devuelve solo los IDs de los contenedores.
- Si algunos contenedores están en ejecución, puedes agregar la opción `-f` (force) para forzar la eliminación:
  `docker rm -f $(docker ps -aq)`


