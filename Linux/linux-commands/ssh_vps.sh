echo "6- CREAR DIRECTORIO .SSH"
mkdir ~/.ssh

echo "7-  CAMBIAR PERMISOS AL DIRECTORIO .SSH SOLO AL DUEÑO"
chmod 700 ~/.ssh

echo "8-  PARA COMPROBAR PERMISOS"
ls -lah

echo "9-  CREAMOS EL ARCHIVO PARA ALMACENAR LLAVES PUBLICAS"
nano ~/.ssh/authorized_keys

echo "10-  COPIAR LA LLAVE PUBLICA PERO EL FORMATO MOSTRADO POR PUTY"
cat ~/.ssh/authorized_keys

echo "11- PERMISOS AL ARCHIVO authorized_keys"
chmod 600 .ssh/authorized_keys

echo "12- PROBAR CONEXION CON PUTY"
exit exit
# https://www.youtube.com/watch?v=mFRBVMp9WAk&list=PLcRkv2Gn2yoR1fYbJGS0wTaThjZIz0xBN&index=7&ab_channel=RingaTech

echo "DESABILITAR INICIO DE SESION POR CONTRASEÑA EDITAR:"
sudo nano /etc/ssh/sshd_config

echo "BUSCAR #PasswordAuthentication yes habilitarlo y cambiarlo por no"
PasswordAuthentication no

echo "REINICIAMOS sshd"
sudo systemctl reload sshd


echo "ver error en caso de no subir servicio"
journalctl -xeu sshd.service
# sudo /etc/init.d/ssh restart
# *************comandos para distros deribadas de redhat *********
echo "para saber quien maneja ssh"
semanage port -l | grep ssh

echo "para agregar puerto en caso de error"
semanage port -a -t ssh_port_t -p tcp NEW_PORT



# sudo /etc/init.d/ssh restart