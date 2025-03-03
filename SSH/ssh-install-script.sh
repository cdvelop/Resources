#!/bin/bash

# Actualizar repositorios
apt-get update

# Instalar SSH
apt-get install -y openssh-server

# Hacer backup del archivo de configuración SSH original
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Configurar SSH para permitir acceso root
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Establecer contraseña para root
echo "root:root" | chpasswd

# Reiniciar el servicio SSH
systemctl enable ssh
systemctl restart ssh

# Verificar el estado del servicio
systemctl status ssh
