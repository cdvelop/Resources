https://learn.microsoft.com/en-us/windows/wsl/networking
https://learn.microsoft.com/es-es/windows/wsl/networking

# ver la ip de la maquina wsl linux desde su consola
ip route show | grep -i default | awk '{ print $3}'