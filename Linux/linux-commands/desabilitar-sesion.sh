echo "DESABILITAR INICIO DE SESION POR CONTRASEÑA EDITAR:"
sudo nano /etc/ssh/sshd_config

echo "BUSCAR #PasswordAuthentication yes habilitarlo y cambiarlo por no"
PasswordAuthentication no #ya biene ok en oracle ubuntu vps

echo "REINICIAMOS sshd"
sudo systemctl reload sshd