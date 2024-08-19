# command_file.sh

read -p "INGRESA NUEVO USUARIO:" USER_NAME

read -p  "INGRESA PASSWORD:" USER_PASSWORD

sudo useradd -p $(openssl passwd -1 $USER_PASSWORD) $USER_NAME

echo "CREANDO USUARIO NUEVO"
sudo adduser NEW_USER_NAME

echo "AGREGANDO USUARIO A CRUPO SUDO"
sudo usermod -aG sudo NEW_USER_NAME


echo "ACTUALIZANDO SISTEMA"
sudo apt update -y && sudo apt upgrade -y


# echo "CAMBIAR AL USUARIO CREADO SALIENDO DE PUTY O"
su - NEW_USER_NAME










