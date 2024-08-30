#!/bin/bash

# Asegúrate de ejecutar este script como root
if [[ $EUID -ne 0 ]]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

# Nombre del archivo de configuración (opcional, puedes cambiarlo)
CONFIG_FILE="/etc/nftables.conf"

# Función para imprimir mensajes de información
info() {
  echo -e "\e[32mINFO:\e[0m $*"
}

# Función para imprimir mensajes de error
error() {
  echo -e "\e[31mERROR:\e[0m $*"
  exit 1
}

# Limpiar las reglas existentes
info "Eliminando reglas existentes..."
nft flush ruleset

# Definir la tabla y cadenas de nftables
info "Configurando tabla y cadenas de nftables..."
nft add table ip filter
nft add chain ip filter input { type filter hook input priority 0 ; }
nft add chain ip filter forward { type filter hook forward priority 0 ; }
nft add chain ip filter output { type filter hook output priority 0 ; }

# Reglas de seguridad básicas
info "Configurando reglas de seguridad básicas..."

# Política por defecto: rechazar todo el tráfico entrante no establecido
nft add rule ip filter input ct state invalid drop
nft add rule ip filter input ct state established,related accept

# Permitir tráfico de loopback (localhost)
nft add rule ip filter input iif lo accept

# Permitir tráfico ICMP (ping)
nft add rule ip filter input ip protocol icmp accept

# Permitir SSH (puerto 2222)
nft add rule ip filter input tcp dport 2222 ct state new accept

# Permitir HTTP (puerto 80)
nft add rule ip filter input tcp dport 80 ct state new accept

# Permitir HTTPS (puerto 443)
nft add rule ip filter input tcp dport 443 ct state new accept

# Política por defecto: rechazar todo lo demás
nft add rule ip filter input drop

# Guardar las reglas en el archivo de configuración
info "Guardando reglas de nftables en ${CONFIG_FILE}..."
nft list ruleset > "${CONFIG_FILE}"

# Verificar si la configuración se ha guardado correctamente
if [[ $? -ne 0 ]]; then
  error "Error al guardar las reglas de nftables."
fi

info "Configuración de nftables completada correctamente."