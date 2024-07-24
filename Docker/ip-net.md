# ver ip de un contenedor docker
ejecuta docker ps para ver el id del contenedor
docker inspect 70cd4e04c947 | grep '"IPAddress"'