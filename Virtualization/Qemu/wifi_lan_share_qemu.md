# KVM/virt-manager: Internet en VMs con Cable o WiFi

## Problema

En Debian 12, las VMs creadas con virt-manager pierden internet cuando el host no tiene cable ethernet conectado (ej: usando solo WiFi en laptop).

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
