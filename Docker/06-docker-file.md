# Docker File para crear contenedor personalizado
- todas las imágenes de docker son basadas en un archivo llamado Dockerfile no puede tener otro nombre
- Dockerfile es un archivo de texto plano que contiene instrucciones para crear una imagen de docker
- las instrucciones de dockerfile se ejecutan de arriba hacia abajo
- una instrucción puede tener varias líneas
- cada instrucción debe ir en una línea diferente

## como crear un archivo Dockerfile
- crear un archivo llamado *Dockerfile* en la raíz del proyecto
ej:
```	docker
# imagen base
FROM node:lts-alpine

# crear carpeta donde arrancara la aplicación en el inicio
RUN mkdir -p /home/app

# de donde se copian los archivos fuente ej: <ruta_origen> <ruta_destino> 
COPY . /home/app

# exponer un puerto para acceder a la aplicación desde otros contenedores o maquina anfitrión ej: EXPOSE <PORT_NUMBER>

EXPOSE 3000

# comando para que la aplicación se inicie ej: CMD ["comando","argumento1","argumento2"...]

CMD ["node","home/app/04-index.js"]]

```