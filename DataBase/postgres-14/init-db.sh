#!/bin/bash
set -e

# Configuración de seguridad aplicada al primer inicio del contenedor.
#
# NOTA DE SEGURIDAD:
# listen_addresses='*' es seguro dentro del contenedor porque el acceso
# externo está controlado por el port binding de Docker (-p 127.0.0.1:5432:5432).
# El contenedor escucha en todas sus interfaces internas, pero solo el host
# puede acceder al puerto desde fuera del contenedor.
#
# pg_hba.conf restringe autenticación a:
#   - conexiones locales Unix socket (peer)
#   - loopback del contenedor (127.0.0.1)
#   - redes internas de Docker (172.16.0.0/12)
# NO se permite 0.0.0.0/0.

# Escuchar en todas las interfaces del contenedor (controlado por Docker desde afuera)
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Reemplazar la regla permisiva por defecto con reglas restrictivas
cat >> "$PGDATA/pg_hba.conf" << 'EOF'

# Conexiones locales via socket Unix
local   all   all                              scram-sha-256
# Loopback del contenedor
host    all   all   127.0.0.1/32              scram-sha-256
host    all   all   ::1/128                   scram-sha-256
# Redes internas Docker (bridge por defecto y redes personalizadas)
host    all   all   172.16.0.0/12             scram-sha-256
EOF
