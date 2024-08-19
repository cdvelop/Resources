echo "grupos a los que pertenece un usuario"
groups user_name

echo "Eliminar un usuario de un grupo mediante gpasswd"
sudo gpasswd -d user_name group_name

echo "Cambiar el propietario de un directorio"
sudo chown new_owner:new_group /path/to/directory

echo "Cambiar el propietario de un directorio y su contenido recursivamente"
sudo chown -R new_owner:new_group /path/to/directory


echo "Ver a qué grupo pertenece un directorio"
ls -ld /path/to/directory | awk '{print $4}'
