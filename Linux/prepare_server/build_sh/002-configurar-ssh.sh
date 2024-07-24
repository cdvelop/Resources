echo "CREAR DIRECTORIO .SSH"
mkdir ~/.ssh &&

echo "CAMBIAR PERMISOS AL DIRECTORIO .SSH SOLO AL DUEÑO"
chmod 700 ~/.ssh &&

echo "AGREGAMOS LLAVE DE CONEXION Y CREAMOS ARCHIVO PARA ALMACENAR LLAVES PUBLICAS"
echo "ssh-rsa xxxxxxxxxxx rsa-key-20221009" > ~/.ssh/authorized_keys &&

echo "PERMISOS AL ARCHIVO authorized_keys"
chmod 600 ~/.ssh/authorized_keys &&