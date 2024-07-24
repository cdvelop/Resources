(
# Desactivando usuario root, permitirá deshabilitar el login del usuario root para dotar al sistema de mayor seguridad:
sudo sed -i 's/^#PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config

# MaxAuthTries: Número de intentos permitidos al introducir la contraseña antes de desconectarnos.
sudo sed -i 's/^#MaxAuthTries 6$/MaxAuthTries 3/' /etc/ssh/sshd_config

#  Número de logins simultáneos desde una IP, para evitar que se pueda utilizar la fuerza bruta con varias sesiones a la vez.
sudo sed -i 's/^#MaxSessions 10$/MaxSessions 3/' /etc/ssh/sshd_config

# LoginGraceTime: Estableceremos el tiempo en segundos necesario para introducir la contraseña, evitando que el atacante tenga que «pensar mucho».
sudo sed -i 's/^#LoginGraceTime 2m$/LoginGraceTime 30/' /etc/ssh/sshd_config

# AllowUsers listado de usuarios permitidos
sudo -- sh -c "echo  \ \ >> /etc/ssh/sshd_config";sudo -- sh -c "echo AllowUsers USER_NAME >> /etc/ssh/sshd_config"

)

# info
# https://www.linuxtotal.com.mx/index.php?cont=info_seyre_004