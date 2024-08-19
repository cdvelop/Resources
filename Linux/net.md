# averiguar cual es mi ip en Debian
hostname -I

# que puertos hay abiertos en mi servidor
ss -tulpn | grep LISTEN
o
sudo nmap localhost