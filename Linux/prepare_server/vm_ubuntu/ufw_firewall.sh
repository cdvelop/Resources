(
echo "CORTAFUEGOS ver aplicaciones configuradas"
sudo ufw app list

echo "configuracion por defecto"
sudo ufw default deny incoming
sudo ufw default allow outgoing


echo "HABLILITAR ANTES DE ACTIVAR CORTAFUEGOS DE LO CONTRARIO EL SISTEMA TE BLOQUEARA"
sudo ufw allow OpenSSH




echo "DESPUES DE ACTIVAR SSH ACTIVAMOS EL CORTAFUEGOS"
sudo ufw enable

echo "HABILITAR PUERTO SSH en ufw"
sudo ufw allow 55436
)


echo "desintalar ufw para la nube de oracle"
sudo ufw disable

sudo apt-get remove ufw

sudo apt-get purge ufw




