# https://getpocket.com/read/3720566536
# https://www.vultr.com/es/docs/setup-sftp-user-accounts-on-ubuntu-20-04/


echo "SOLO SI ESTA INSTALADO SSH CAMBIAR CONFIGURACION SSHD"
sudo nano /etc/ssh/sshd_config

echo "cambiar puerto ssh NEW_PORT"
sudo ufw allow NEW_PORT/tcp

echo "PEGAR AL FINAL DEL ARCHIVO LA CONFUGURACION"
#coincidir el grupo de usuarios sftp.
Match Group sftp 
#restringe el acceso a directorios dentro del directorio de inicio del usuario.
ChrootDirectory /home 
ChrootDirectory /home/USER_NAME/PROJECT_NAME 
#No permitir pantallas gráficas.
X11Forwarding no 
#deshabilita el reenvío TCP.
AllowTcpForwarding no 
#habilite SFTP solo sin acceso de shell.
ForceCommand internal-sftp 

echo "Paso 3: reinicie los servicios SSH D"
sudo systemctl restart sshd

echo "verificar si el servicio esta ok"
sudo systemctl status sshd

echo "verificar que el demonio SSH es listeningEn el nuevo puerto"
ss -an | grep NEW_PORT

echo "config SSH usuarios de SFTP ok A continuación, crear nueva cuenta usuario SFTP y asignará permisos."
sudo addgroup sftp

echo "agregar usuario al grupo"
sudo usermod -aG sftp USER_NAME



