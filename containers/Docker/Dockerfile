FROM node:18

# crear carpeta para almacenar la app
RUN mkdir -p /home/app

# copiar código de la aplicación a la carpeta creada
COPY appnode /home/app

# cambiar al directorio de la aplicación
WORKDIR /home/app

# instalar dependencias
RUN npm install

# exponer puerto
EXPOSE 3000

# ejecutar aplicación
CMD ["node", "index.js"]