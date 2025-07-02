# Volumes
añadir persistencia a los contenedores de docker

## ejemplo creaun un volumen con bash

```bash
docker volume create --driver local --opt type=none --opt device="$DOCKER_VOLUMES/FOOOCUS_DATA" --opt o=bind FOOOCUS_DATA


docker volume create --driver local --opt type=none --opt device="$DOCKER_MODELS" --opt o=bind DOCKER_MODELS
```

## ejemplo de un volumen en docker-compose

```yaml
volumes:
  FOOOCUS_DATA:
    driver_opts:
      type: none
      device: ${DOCKER_VOLUMES}/FOOOCUS_DATA
      o: bind
    MODELS_DATA:
    driver_opts:
      type: none
      device: ${DOCKER_MODELS}
      o: bind

```

## comprobar si el bind mount funciona
creas un archivo dentro del contenedor en la ruta models, ese archivo aparecerá en tu carpeta local `/c/Users/YOU_USER/Downloads/FOOOCUS_DATA` y viceversa.

Puedes probarlo así (en tu terminal):

```bash
docker exec -it local-ai bash

#Luego, dentro del contenedor:
touch /models/prueba_desde_contenedor.txt
ls /models
```

Después, revisa tu carpeta local y verás el archivo creado.  
Esto confirma que el bind mount funciona correctamente.

## existen tres tipo de volúmenes

- *anónimos*: 
    - lo bueno: solo vasta indicar la ruta y docker se encarga de decidir donde sera montada
    - lo malo: no se pueden reutilizar ni compartir entre contenedores

- *anfitrión o host*: mapean una carpeta del host al contenedor
    - lo bueno: se puede acceder directamente desde el host
    - lo malo: tienes que decidir la ruta manualmente

- *nombrados*: se pueden reutilizar y compartir entre contenedores
    - lo bueno: se pueden montar en varios contenedores y referenciar la ruta desde otro contenedor
    - lo malo: se debe crear y administrar manualmente


# ver los volúmenes
docker volume ls

# inspeccionar un volume
docker volume inspect <volume_name>

# eliminar
docker volume rm <volume_name>