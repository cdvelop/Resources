#!/bin/bash

# Habilitar el acceso SSH con contraseña para root
enable_root_ssh() {
    echo "Habilitando el acceso SSH con contraseña para root..."
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo "Acceso SSH con contraseña para root habilitado."
}

# Deshabilitar el acceso SSH con contraseña para root
disable_root_ssh() {
    echo "Deshabilitando el acceso SSH con contraseña para root..."
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo "Acceso SSH con contraseña para root deshabilitado."
}

# Establecer o cambiar la contraseña de root
set_root_password() {
    echo "Estableciendo o cambiando la contraseña de root..."
    sudo passwd root
}

# Menú para elegir habilitar o deshabilitar el acceso root por SSH
echo "Seleccione una opción:"
echo "1. Habilitar acceso SSH con contraseña para root"
echo "2. Deshabilitar acceso SSH con contraseña para root"
echo "3. Establecer o cambiar la contraseña de root"
read -p "Opción (1, 2, 3): " OPTION

case $OPTION in
    1)
        enable_root_ssh
        ;;
    2)
        disable_root_ssh
        ;;
    3)
        set_root_password
        ;;
    *)
        echo "Opción no válida."
        ;;
esac
