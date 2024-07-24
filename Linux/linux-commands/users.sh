echo "grupos a los que pertenece un usuario"
groups user_name

echo "Eliminar un usuario de un grupo mediante gpasswd"
sudo gpasswd -d user_name group_name