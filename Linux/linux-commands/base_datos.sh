
echo "listar versiones en ubuntu"
apt-cache policy postgresql-9.5*

echo "instalar postgreSQL 9.5"
sudo apt install postgresql95-server postgresql95 -y &&

echo "iniciar el proceso para las bases de datos:"

echo "iniciar el proceso para las bases de datos ubuntu:"

sudo  /usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main -l logfile start



echo "estado db"
sudo service postgresql status

echo "para detener o iniciar start stop"
sudo service postgresql stop


echo "ingresar a posgres"
sudo -i -u postgres

echo "salir "
exit

echo "crear base de datos"
createdb nombredb

echo "consulta hora"
select current_time;