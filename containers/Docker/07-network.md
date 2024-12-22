# docker network
para comunicar contenedores entres si es necesario crear redes docker

## listar redes existentes
`docker network ls`

## crear red
`docker network create my-network`

## eliminar red
`docker network rm my-network`

## ejemplo creando 2 contenedores el de la db y el de node agregando la red llamada dockernet
```bash
docker create --name monguito -p27017:27017 --network dockernet -e MONGO_INITDB_ROOT_USERNAME=cesar -e MONGO_INITDB_ROOT_PASSWORD=123 dannyben/alpine-mongo:latest

docker create --name nodecito -p3000:3000 --network dockernet nodeapp:v1
```

## arrancar ambos contenedores
docker start monguito nodecito