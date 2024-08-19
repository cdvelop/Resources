#!/bin/bash

# Prompt for new user details
read -p "INGRESA NUEVO USUARIO: " USER_NAME
read -s -p "INGRESA PASSWORD: " USER_PASSWORD
echo

# Create the new user
echo "CREANDO USUARIO NUEVO"
sudo useradd -m -p $(openssl passwd -1 "$USER_PASSWORD") "$USER_NAME"

# Add the user to sudo group
echo "AGREGANDO USUARIO A GRUPO SUDO"
sudo usermod -aG sudo "$USER_NAME"



echo "Usuario $USER_NAME creado exitosamente. Puede iniciar sesión con el nuevo usuario usando 'su - $USER_NAME'"
