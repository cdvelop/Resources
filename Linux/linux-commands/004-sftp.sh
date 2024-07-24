(
# ****** SFTP *************
echo "comentar remplazar y agregar"
# sudo sed -i 's|Subsystem sftp|#Subsystem sftp|' /etc/ssh/sshd_config
# sudo sed -i 's|Subsystem      sftp|#Subsystem sftp|' /etc/ssh/sshd_config

# sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo Subsystem sftp internal-sftp >> /etc/ssh/sshd_config"

#habilite SFTP solo sin acceso de shell.
# sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo ForceCommand internal-sftp >> /etc/ssh/sshd_config"

#No permitir pantallas gráficas en sftp.
sudo sed -i 's/^X11Forwarding yes$/X11Forwarding no/' /etc/ssh/sshd_config
# sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo X11Forwarding no >> /etc/ssh/sshd_config"

#deshabilita el reenvío TCP.
sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo AllowTcpForwarding no >> /etc/ssh/sshd_config"

echo "config SSH usuarios de SFTP ok A continuación, crear nueva cuenta usuario SFTP y asignará permisos."
sudo addgroup sftp

#restringe el acceso a directorios dentro del directorio de inicio del usuario.
sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo ChrootDirectory /home/sftp/ >> /etc/ssh/sshd_config"

#coincidir el grupo de usuarios sftp.
sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo Match Group sftp >> /etc/ssh/sshd_config"

echo "agregar usuario USER_NAME al grupo sftp"
sudo usermod -aG sftp USER_NAME

echo "crear carpeta sftp en directorio home"
sudo mkdir /home/sftp

echo "agregar permisos usuario root grupo root"
sudo chown root:root /home/sftp/

echo "crear carpeta deploy con permisos de usuario"
sudo mkdir /home/sftp/deploy

echo "agregar permisos usuario USER_NAME grupo sftp"
sudo chown USER_NAME:sftp /home/sftp/deploy

echo "reiniciar servicio sshd"
sudo systemctl restart sshd

echo "verificar si el servicio esta ok"
sudo systemctl status sshd
)

echo "ver archivo ssh_config"
sudo nano /etc/ssh/sshd_config 

echo "chequear version openssh-server tiene que ser > a 4. 9"
sudo dpkg -l|grep ssh



