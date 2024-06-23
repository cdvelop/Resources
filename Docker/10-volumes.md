# Volumes
añadir persistencia a los contenedores de docker

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