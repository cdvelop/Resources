echo "verificar configuración actual de fecha y zona horaria"
timedatectl

echo "listado zonas"
timedatectl list-timezones

echo "Para filtrarlo un poco"
timedatectl list-timezones | grep -i america


echo "seleccionar zona horaria America/Santiago para el sistema"
sudo timedatectl set-timezone America/Santiago