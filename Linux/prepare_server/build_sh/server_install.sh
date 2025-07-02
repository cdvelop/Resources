#!/bin/bash
echo "ACTUALIZANDO SISTEMA"
# sudo apt update -y && sudo apt upgrade -y &&
echo "CREAR DIRECTORIO .SSH"
mkdir ~/.ssh &&

echo "CAMBIAR PERMISOS AL DIRECTORIO .SSH SOLO AL DUEÑO"
chmod 700 ~/.ssh &&

echo "AGREGAMOS LLAVE DE CONEXION Y CREAMOS ARCHIVO PARA ALMACENAR LLAVES PUBLICAS"
echo "ssh-rsa XXXXXXXXXX rsa-key-111111111" > ~/.ssh/authorized_keys &&

echo "PERMISOS AL ARCHIVO authorized_keys"
chmod 600 ~/.ssh/authorized_keys &&
echo "seleccionar zona horaria America/Santiago para el sistema"
sudo timedatectl set-timezone America/Santiago &&
echo "instalar postgreSQL 9.5"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update &&
sudo apt-get install postgresql-9.5 -y &&
read -rsp $'Press any key to continue...\n' -n1 key
