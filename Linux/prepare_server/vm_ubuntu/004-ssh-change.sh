(
echo "ver todos los servicios que utilizan ssh"
grep ssh /etc/services

echo "cambiar puerto ssh 22 a PORT_NEW"
sudo sed -i 's/^#Port 22$/Port PORT_NEW/' /etc/ssh/sshd_config

echo "reiniciar servicio sshd"
sudo systemctl restart sshd


echo "instalar firewall ufw"
sudo apt install ufw -y

echo "HABILITAR PUERTO SSH NUEVO"
sudo ufw allow PORT_NEW

echo "habilitar servidor https 443"
sudo ufw allow 443

echo "ver estado ssh"
systemctl status sshd

echo "ACTIVAMOS EL CORTAFUEGOS"
sudo ufw enable

echo "ver si el cortafuegos esta presente"
sudo ufw status
)





