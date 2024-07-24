(
echo "CREAR DIRECTORIO .SSH"
mkdir ~/.ssh &&

echo "CAMBIAR PERMISOS AL DIRECTORIO .SSH SOLO AL DUEÑO"
chmod 700 ~/.ssh &&

echo "AGREGAMOS LLAVE DE CONEXION Y CREAMOS ARCHIVO PARA ALMACENAR LLAVES PUBLICAS"
echo "ssh-rsa XXXXXXXXXXXXXXXXXX rsa-key-111111111" > ~/.ssh/authorized_keys &&

echo "PERMISOS AL ARCHIVO authorized_keys"
chmod 600 ~/.ssh/authorized_keys

echo "ver grupo agregado"
groups USER_NAME &&

echo "ver llave ssh agregada"
sudo nano ~/.ssh/authorized_keys

echo "borrar usuario ubuntu con directorio"
sudo userdel -r -f ubuntu
sudo deluser --system --remove-home ubuntu
)