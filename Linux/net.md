# averiguar cual es mi ip en Debian
hostname -I

# que puertos hay abiertos en mi servidor
ss -tulpn | grep LISTEN
o
sudo nmap localhost

---

# Eliminar bridge br0 y usar ethernet directo

## Problema

Tener un bridge (br0) con el ethernet como puerto esclavo causa que al desconectar
el cable, la ruta default siga apuntando al bridge (que no baja automaticamente).
El WiFi tarda mucho en tomar la conexion porque el sistema sigue intentando usar br0.

## Diagnostico

```bash
# Ver rutas default (si hay dos, el bridge tiene prioridad sobre wifi)
ip route show default

# Ver estado de las conexiones
nmcli device status

# Ver que eno1 esta como esclavo del bridge
nmcli connection show br0
```

## Solucion: eliminar bridge, usar ethernet directo

```bash
# Desactivar y eliminar el bridge
sudo nmcli connection down br0
sudo nmcli connection delete br0
sudo nmcli connection delete br0-port1

# Crear conexion ethernet normal (sin bridge)
sudo nmcli connection add type ethernet con-name "Ethernet" ifname eno1

# Verificar
ip route show default
nmcli device status
```

## Resultado

- Con cable: ethernet toma la ruta default (metric menor)
- Sin cable: wifi toma la ruta default inmediatamente (eno1 baja y desaparece la ruta)
- Las VMs de KVM usan la red NAT `default` (virbr0), no necesitan bridge