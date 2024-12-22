# comandos docker
asegurar que *docker desktop* este corriendo antes de ejecutar los comandos

## ver imágenes docker
`docker images`

## descargar imágenes docker
docker pull <image_name>  
- ej: `docker pull python:3.9-alpine` or `docker pull python` or 
`docker pull dannyben/alpine-mongo:latest`


### si arroja error en el caso de tener el chip m1 apple
- ej: `no matching manifest for linux/arm64/v8 in the manifest list entries`
para solucionarlo indicamos la plataforma que necesitamos
- ej: `docker pull --platform linux/amd64 python:3.9-alpine`


## eliminar imágenes docker:
`docker rmi <image_name>`
- ej: `docker rmi python:3.9-alpine`

## ver como fue creada una imagen docker
`docker history <image_name>`
- ej: `docker history python:3.9-alpine`

Este comando muestra las capas de la imagen y los comandos utilizados para crearlas, proporcionando información sobre cómo se construyó la imagen.
