(
echo "instalar cortafuegos ufw"
sudo apt install ufw

echo "configuracion por defecto"
sudo ufw default deny incoming
sudo ufw default allow outgoing





echo "verificar si se cambio puerto"
sudo apt install net-tools &&

sudo netstat -tlp | grep ssh

echo "chequear ssh"
sudo apt list --installed | grep openssh-server
)


)