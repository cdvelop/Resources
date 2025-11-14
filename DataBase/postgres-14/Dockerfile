# Dockerfile para PostgreSQL 14 usando la imagen oficial de Alpine

# Usar la imagen oficial de PostgreSQL 14 basada en Alpine Linux.
# Es ligera, segura y mantenida por la comunidad.
FROM postgres:14-alpine

# Etiqueta para mantener la información del autor
LABEL maintainer="GitHub Copilot"

# Copiar un script de inicialización para permitir conexiones remotas.
# La imagen base de postgres ejecutará automáticamente cualquier script .sh
# en este directorio al iniciar el contenedor por primera vez.
COPY init-db.sh /docker-entrypoint-initdb.d/

# El puerto 5432 y el comando de inicio ya están definidos en la imagen base.
