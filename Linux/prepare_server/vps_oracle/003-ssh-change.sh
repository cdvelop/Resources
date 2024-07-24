echo "ver todos los servicios que utilizan ssh"
grep ssh /etc/services

(
echo "cambiar puerto ssh 22 a NEW_PORT"
sudo sed -i 's/^#Port 22$/Port NEW_PORT/' /etc/ssh/sshd_config

echo "reiniciar servicio sshd"
sudo systemctl restart sshd

echo "despues de habilitar los puertos en la nube oracle no recomendado instalar ufw pero si firewalld"
sudo apt install firewalld -y
sudo systemctl enable firewalld
  
echo "HABILITAR PUERTO SSH NUEVO"
sudo firewall-cmd --permanent --zone=public --add-port=NEW_PORT/tcp

echo "habilitar servidor https 443"
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp

echo "reiniciar firewalld"
sudo firewall-cmd --reload

echo "ver estado ssh"
systemctl status sshd
)

echo "ver estado firewalld"
sudo firewall-cmd --state

echo "Para ver el estatus del demonio FirewallD"
sudo systemctl status firewalld

echo "verificar que el demonio SSH esta eschuchando en el nuevo puerto"
ss -an | grep NEW_PORT

# En caso de que haya algún problema, asegúrese de que el servicio de firewall
# use iptables como FirewallBackenden su configuración: 
# /etc/firewalld/firewalld.config

# fuente configuracion
# https://smalldata.tech/blog/2021/09/08/how-to-open-ports-on-oracle-cloud-vm-running-on-ubuntu-20-04?utm_source=pocket_mylist





