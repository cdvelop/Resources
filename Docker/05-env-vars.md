# ENVIRONMENT VARS
ejemplo de variables de entorno para mongo
1- ir a:
https://hub.docker.com/_/mongo

2- en el apartado de: 
Environment Variables

nos encontraremos con la configuraciones de las variables de conexión ej:
MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD

ej:

```bash
docker run --name monguito -p27017:27017 -e MONGO_INITDB_ROOT_USERNAME=cesar -e MONGO_INITDB_ROOT_PASSWORD=123 -d dannyben/alpine-mongo

```
