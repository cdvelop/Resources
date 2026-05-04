# KVM/virt-manager: Internet en VMs con Cable o WiFi

## Problema

En Debian 12/13, las VMs creadas con virt-manager pierden internet cuando el host no tiene cable ethernet conectado (ej: usando solo WiFi en laptop).

Esto ocurre porque la red virtual esta configurada en modo bridge atado a la interfaz ethernet. Cuando esa interfaz baja, las VMs quedan sin red.

## Solucion: Usar red NAT (red virtual default)

libvirt incluye una red virtual llamada `default` que funciona como NAT. Enruta el trafico de las VMs a traves de cualquier conexion activa del host (cable, WiFi, tethering), sin depender de una interfaz especifica.

### Paso 1: Verificar que la red virtual "default" existe y esta activa

```bash
sudo virsh net-list --all
```

Salida esperada:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

Si no aparece o esta inactiva:

```bash
# Iniciar la red
sudo virsh net-start default

# Configurar para que inicie automaticamente
sudo virsh net-autostart default
```

Si no existe en absoluto:

```bash
# Crear la red default
sudo virsh net-define /usr/share/libvirt/networks/default.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

### Paso 2: Cambiar la red de una VM existente (virt-manager GUI)

1. Abrir **virt-manager**
2. Click derecho en la VM > **Abrir**
3. Ir al icono de bombilla (**Detalles del hardware**)
4. Seleccionar **NIC** (tarjeta de red) en el panel izquierdo
5. En **Network source** cambiar de:
   - `Bridge device...` o `Direct attachment...`
   - A: **Virtual network 'default': NAT**
6. En **Device model** seleccionar: **virtio**
7. Click en **Apply**

### Paso 3: Cambiar la red via linea de comandos (alternativa)

Si prefieres usar la terminal:

```bash
# Ver la configuracion actual de la VM
sudo virsh dumpxml nombre-de-la-vm | grep -A 5 "<interface"
```

Salida tipica con bridge (el problema):
```xml
<interface type='bridge'>
  <source bridge='br0'/>
  <model type='virtio'/>
</interface>
```

Editar la VM:

```bash
sudo virsh edit nombre-de-la-vm
```

Cambiar la seccion `<interface>` a:

```xml
<interface type='network'>
  <source network='default'/>
  <model type='virtio'/>
</interface>
```

Guardar y cerrar el editor.

### Paso 4: Iniciar la VM y verificar internet

1. Iniciar la VM desde virt-manager
2. Dentro de la VM ejecutar:

```bash
# Ver IP asignada (deberia ser 192.168.122.x)
ip addr show

# Probar conectividad
ping -c 3 8.8.8.8

# Probar DNS
ping -c 3 google.com
```

La VM obtendra automaticamente una IP en el rango `192.168.122.0/24` via DHCP de libvirt.

### Paso 5: Acceder a la VM por SSH desde el host (opcional)

Con NAT, la VM recibe una IP en `192.168.122.x` accesible desde el host:

```bash
# Ver la IP asignada a la VM
sudo virsh domifaddr nombre-de-la-vm

# Conectar por SSH
ssh usuario@192.168.122.xxx
```

A diferencia del NAT de QEMU por comandos, la red NAT de libvirt SI permite conectar desde el host a la VM directamente sin port forwarding.

## Para VMs nuevas

Al crear una VM nueva en virt-manager:

1. En el paso de configuracion de red, seleccionar **Virtual network 'default': NAT**
2. Esto es todo. La VM tendra internet sin importar si el host usa cable o WiFi.

## Resumen

| Caracteristica         | Bridge (actual)              | NAT virtual default         |
|------------------------|------------------------------|-----------------------------|
| Funciona con cable     | Si                           | Si                          |
| Funciona con WiFi      | No (la mayoria de drivers)   | Si                          |
| VM accesible desde host| Si                           | Si (192.168.122.x)          |
| VM accesible en LAN    | Si                           | No                          |
| Configuracion en host  | Requiere bridge + tap        | Solo red default activa     |
| Rendimiento            | Mejor                        | Ligeramente menor           |

## Nota: Eliminar bridge br0 del host

Si antes usabas bridge (br0) para las VMs, eliminalo para evitar problemas de red
cuando desconectas el cable ethernet. Ver documentacion en `../../Linux/net.md`.

```bash
sudo nmcli connection down br0
sudo nmcli connection delete br0
sudo nmcli connection delete br0-port1
sudo nmcli connection add type ethernet con-name "Ethernet" ifname eno1
```

## Troubleshooting: dnsmasq no responde DHCP (Debian 13)

En Debian 13 (Trixie) puede ocurrir que dnsmasq de libvirt no responda a los DHCP Discover de las VMs, dejandolas sin IP (169.254.x.x / APIPA).

### Sintomas

- La VM envia DHCP Discover (visible con `tcpdump -i virbr0 -n port 67 or port 68`) pero no recibe DHCP Offer
- `sudo virsh domifaddr nombre-vm` no muestra IP
- La VM obtiene IP APIPA (169.254.x.x)

### Diagnostico

```bash
# Verificar que dnsmasq esta corriendo
sudo ps aux | grep dnsmasq

# Verificar que escucha en virbr0
sudo ss -ulnp | grep 67

# Verificar que el archivo de leases existe
ls -la /var/lib/libvirt/dnsmasq/default.leases

# Capturar trafico DHCP
sudo tcpdump -i virbr0 -n port 67 or port 68 -v
```

### Solucion 1: Recrear archivo de leases

Si `/var/lib/libvirt/dnsmasq/default.leases` no existe:

```bash
sudo touch /var/lib/libvirt/dnsmasq/default.leases
sudo chmod 644 /var/lib/libvirt/dnsmasq/default.leases
```

### Solucion 2: Reiniciar red y VMs (importante el orden)

Despues de reiniciar la red virtual, las VMs pierden conexion al bridge (virbr0 queda en estado `NO-CARRIER`/`DOWN`). Es necesario reiniciar las VMs:

```bash
sudo virsh net-destroy default
sudo virsh net-start default

# IMPORTANTE: reiniciar las VMs para que se reconecten al bridge
sudo virsh destroy nombre-vm
sudo virsh start nombre-vm
```

Verificar que virbr0 esta UP despues de iniciar las VMs:

```bash
ip addr show virbr0
# Debe mostrar: <BROADCAST,MULTICAST,UP,LOWER_UP> state UP
# Si muestra NO-CARRIER o DOWN, las VMs no estan conectadas
```

### Solucion 3: IP estatica en la VM (evita DHCP)

Si dnsmasq sigue sin responder, configurar IP estatica dentro de la VM:

**Windows (CMD como administrador):**
```
netsh interface ip set address "Ethernet" static 192.168.122.50 255.255.255.0 192.168.122.1
netsh interface ip set dns "Ethernet" static 8.8.8.8
netsh interface ip add dns "Ethernet" 1.1.1.1 index=2
```

**Linux:**
```bash
sudo ip addr add 192.168.122.50/24 dev enp1s0
sudo ip route add default via 192.168.122.1
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### Nota sobre nftables y reinicio de reglas

En Debian 13, `nft list ruleset` puede incluir reglas xtables compat (ej: `xt target "CHECKSUM"`) que no se pueden restaurar con `nft -f`. Si necesitas hacer backup/restore de reglas:

```bash
# Backup
sudo nft list ruleset > /tmp/nft-backup.conf

# Si el restore falla por xtables compat, reiniciar los servicios en su lugar:
sudo systemctl restart libvirtd
sudo systemctl restart docker
```

### Nota sobre cambio de modelo de NIC

Al cambiar el modelo de NIC (ej: de `virtio` a `e1000e`), Windows ve un adaptador nuevo. La configuracion de IP del adaptador anterior no se transfiere. Hay que reconfigurar la IP en el nuevo adaptador.
