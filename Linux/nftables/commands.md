# nftables

ver estado del servicio nftables
```bash
#systemctl status nftables.service

# ver estado en una maquina remota
ssh root@$IP_VM "systemctl status nftables.service"
```

ver configuración ficha de configuración
```bash
ssh root@$IP_VM cat /etc/nftables.conf
```



crear una tabla solo si no existe
```bash

nft add table inet filter
```
donde inet es la familia de protocolos (ipv4, ipv6, etc) y filter es el nombre de la tabla

vaciar tabla
```bash
ssh root@$IP_VM nft flush table inet filter

```

borrar tabla
```bash
ssh root@$IP_VM nft delete table inet filter
```


para almacenar reglas directamente en el archivo de configuración
```bash
ssh root@$IP_VM nft list ruleset > /etc/nftables.conf
```

reiniciar servicio
```bash
ssh root@$IP_VM systemctl restart nftables.service
```