
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

## eliminar un contenedor creado por su nombre
`docker rm <CONTAINER_NAME>` ej: `docker rm ecstatic_vaughan`

## asignar nombre a un contenedor cuando se crea
`docker create --name <CONTAINER_NAME> <FROM_IMAGE_NAME>`
-ej: `docker create --name monguito mongo `


## ver si el contenedor se ejecuto de forma correcta (logs)
`docker logs <CONTAINER_NAME>`
- ej: `docker logs monguito` (queda en espera la consola)

## quedar en escucha de los logs del contenedor (follow)
`docker logs -f <CONTAINER_NAME>` (mostrara en tiempo real)



