#!/bin/bash
set -e

# Modificar pg_hba.conf para permitir que cualquier IP se conecte con contraseña md5.
# Esto es seguro para desarrollo, ya que el puerto solo estará expuesto en tu máquina local.
echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

# Modificar postgresql.conf para que el servidor escuche en todas las interfaces de red.
# Esto es necesario para que puedas conectarte desde tu Debian 12 al contenedor.
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"
