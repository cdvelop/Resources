(
echo "ACTUALIZANDO SISTEMA"
sudo apt update -y && sudo apt upgrade -y

echo "INSTALAR EDITOR NANO"
sudo apt install nano -y

echo "seleccionar zona horaria America/Santiago para el sistema"
sudo timedatectl set-timezone America/Santiago

echo "CREANDO USUARIO NUEVO"
sudo adduser USER_NAME

echo "AGREGANDO USUARIO A CRUPO SUDO"
sudo usermod -aG sudo USER_NAME

echo "CAMBIAR AL USUARIO CREADO"
su - USER_NAME
)