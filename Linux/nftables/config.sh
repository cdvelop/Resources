#!/bin/bash
# Instala y configura nftables en Debian
# Aplica la configuración de laptop de desarrollo con Docker + SMB + DLNA
#
# Uso: sudo bash config.sh
#
# Lo que hace:
#   1. Instala nftables si no está instalado
#   2. Copia nftables.conf a /etc/nftables.conf
#   3. Recarga las reglas (sin afectar tablas de Docker/libvirt)
#   4. Habilita el servicio para que arranque en el boot

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: ejecutar como root: sudo bash $0"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_SRC="${SCRIPT_DIR}/nftables.conf"
CONF_DST="/etc/nftables.conf"

info() { echo -e "\e[32m[OK]\e[0m $*"; }
err()  { echo -e "\e[31m[ERROR]\e[0m $*"; exit 1; }

# 1. Instalar si no está presente
if ! command -v nft &>/dev/null; then
  info "Instalando nftables..."
  apt-get update -qq && apt-get install -y nftables
fi
info "nftables $(nft --version | head -1)"

# 2. Copiar configuración
cp "$CONF_SRC" "$CONF_DST"
info "Configuración copiada a $CONF_DST"

# 3. Validar antes de aplicar
nft -c -f "$CONF_DST" || err "El archivo de configuración tiene errores de sintaxis"
info "Sintaxis válida"

# 4. Aplicar reglas (flush + load — no toca tablas de Docker/libvirt)
nft -f "$CONF_DST"
info "Reglas aplicadas"

# 5. Habilitar y arrancar el servicio
systemctl enable nftables
systemctl restart nftables
systemctl is-active --quiet nftables && info "Servicio nftables activo" || err "El servicio no arrancó"

echo ""
info "Configuración completada. Reglas activas:"
nft list table inet filter
