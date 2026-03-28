# Comandos nftables

## Estado del servicio

```bash
sudo systemctl status nftables.service
sudo systemctl restart nftables.service
```

## Ver reglas activas

```bash
# Todo el ruleset (incluye Docker, libvirt, etc.)
sudo nft list ruleset

# Solo nuestra tabla
sudo nft list table inet filter
```

## Ver configuración guardada

```bash
cat /etc/nftables.conf
```

## Aplicar configuración manualmente

```bash
# Validar sintaxis sin aplicar
sudo nft -c -f /etc/nftables.conf

# Aplicar (hace flush + load según lo que diga el config)
sudo nft -f /etc/nftables.conf
```

## Tablas

```bash
# Crear tabla solo si no existe
sudo nft add table inet filter

# Limpiar solo nuestra tabla (NO tocar Docker/libvirt)
sudo nft flush table inet filter

# Borrar tabla completa
sudo nft delete table inet filter
```

## Unidades systemd fallidas

```bash
systemctl --failed
sudo journalctl -u nftables -n 30
```

## Comandos en máquina remota

```bash
ssh root@$IP_VM "systemctl status nftables.service"
ssh root@$IP_VM "nft list table inet filter"
ssh root@$IP_VM "cat /etc/nftables.conf"
ssh root@$IP_VM "nft flush table inet filter && nft -f /etc/nftables.conf"
```

## ADVERTENCIA: no usar estos comandos para guardar config

```bash
# MAL — guarda tablas de Docker/libvirt que no deben estar en el config
nft list ruleset > /etc/nftables.conf
```

Editar `/etc/nftables.conf` directamente y asegurarse de que empiece con
`flush table inet filter`.
