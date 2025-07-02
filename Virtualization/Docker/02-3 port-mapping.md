# Port Mapping

Host

     node[3000] 
     mongo[27017]

## crear contenedor con mapeo de puerto publico
`docker create -p<host_port>:<container_port> <image_name> --name <container_name> <from_image_name>`
ej: docker create -p27017:27017 --name monguito mongo
result: CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                      NAMES
        01006a8bcfe5   mongo  "docker-entrypoint.s…"   41 seconds ago    Up 20 seconds   0.0.0.0:27017->27017/tcp   monguito

