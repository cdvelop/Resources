# Docker Compose

## iniciar 
docker-compose up

## iniciar con un fichero determinado
docker-compose -f nombre-del-fichero.yml up

## limpiar todo
docker-compose down

## ver imágenes creadas por docker compose
docker-compose images

## para forzar la reconstrucción de las imágenes
docker-compose build

## ver el estado del cluster docker compose
docker-compose ps

## detener todos los servicios
docker-compose stop