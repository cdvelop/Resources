(
echo "CREAR DIRECTORIO .SSH"
mkdir ~/.ssh

echo "CAMBIAR PERMISOS AL DIRECTORIO .SSH SOLO AL DUEÑO"
chmod 700 ~/.ssh

echo "PARA COMPROBAR PERMISOS"
# ls -lah

echo "CREAMOS EL ARCHIVO PARA ALMACENAR LLAVES PUBLICAS"
nano ~/.ssh/authorized_keys

echo "COPIAR LA LLAVE PUBLICA PERO EL FORMATO MOSTRADO POR PUTY"
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXX rsa-key-111111111" > ~/.ssh/authorized_keys &&

echo "PERMISOS AL ARCHIVO authorized_keys"
chmod 600 .ssh/authorized_keys

# ***********CAMBIANDO PUERTO 22
echo "cambiar puerto ssh 22 a 55436"
sudo sed -i 's/^#Port 22$/Port 55436/' /etc/ssh/sshd_config

echo "reiniciar servicio ssh"
sudo service ssh restart

echo "HABILITAR PUERTO SSH en ufw"
sudo ufw allow 55436

echo "DESPUES DE ACTIVAR SSH ACTIVAMOS EL CORTAFUEGOS"
sudo ufw enable

echo "12- PROBAR CONEXION CON PUTY"
)
# exit exit
# https://www.youtube.com/watch?v=mFRBVMp9WAk&list=PLcRkv2Gn2yoR1fYbJGS0wTaThjZIz0xBN&index=7&ab_channel=RingaTech


