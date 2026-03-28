#!/bin/bash
set -e

# Configuración de seguridad aplicada al primer inicio del contenedor.
#
# NOTA DE SEGURIDAD:
# listen_addresses='*' es seguro dentro del contenedor porque el acceso
# externo está controlado por el port binding de Docker (-p 127.0.0.1:5432:5432).
#
# pg_hba.conf restringe autenticación a:
#   - conexiones locales Unix socket
#   - loopback del contenedor
#   - redes internas de Docker (172.16.0.0/12)
# NO se permite 0.0.0.0/0.
#
# Nota: PostgreSQL 9.5 usa md5 (scram-sha-256 no está disponible en esta versión)

echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

cat >> "$PGDATA/pg_hba.conf" << 'EOF'

# Conexiones locales via socket Unix
local   all   all                              md5
# Loopback del contenedor
host    all   all   127.0.0.1/32              md5
host    all   all   ::1/128                   md5
# Redes internas Docker
host    all   all   172.16.0.0/12             md5
EOF
