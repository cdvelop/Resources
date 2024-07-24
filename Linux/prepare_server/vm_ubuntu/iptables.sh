echo "ver estado"
sudo iptables -L -v

echo "agregar puerto"
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport NEW_PORT -j ACCEPT

 sudo netfilter-persistent save