# Acceso a servicios en VM KVM desde el host Debian 13

## Entorno

| Elemento | Valor |
|---|---|
| Host | Debian 13 |
| VM | `win-srv-2012-r2` (Windows Server 2012 R2) |
| Hipervisor | KVM/QEMU gestionado con `libvirt` |
| Red VM | NAT via `virbr0` — subred `192.168.122.0/24` |
| IP host en el bridge | `192.168.122.1` ⚠️ Esta es la IP del host vista desde la VM — agrégala a la lista blanca del servicio web para tener acceso |
| IP de la VM | `192.168.122.10` |
| Puerto del servicio web | `1100` |

> **Nota:** Todos los comandos `virsh` usan `-c qemu:///system` porque la VM corre bajo el demonio del sistema (`libvirtd`), no en la sesión de usuario. Sin ese flag, virsh conecta al socket de sesión y no encuentra la red ni la VM.

> La IP de la VM puede cambiar si el servidor DHCP de libvirt le asigna una diferente al reiniciar.
> Ver sección [Verificar la IP actual de la VM](#verificar-la-ip-actual-de-la-vm).

---

## Requisito previo: whitelist de IP en el servicio web

El servicio en el puerto 1100 restringe acceso por IP. Desde la VM, el host siempre aparece con la IP del bridge:

```
192.168.122.1
```

**Esta IP debe estar en la lista blanca del servicio web**, de lo contrario todas las peticiones desde el host serán rechazadas.

---

## Acceso directo desde el host

El bridge `virbr0` conecta el host directamente a la red interna de las VMs.
Desde el host puedes acceder al servicio web sin configuración adicional:

```
http://192.168.122.10:1100
```

Ábrelo en el navegador del host o prueba con:

```bash
curl http://192.168.122.10:1100
```

---

## Verificar la IP actual de la VM

La VM usa DHCP interno de libvirt. Para confirmar la IP asignada:

```bash
# Método 1: tabla de vecinos (ARP) — rápido, la VM debe haber comunicado recientemente
ip neigh show dev virbr0

# Método 2: via libvirt (requiere qemu-guest-agent instalado en la VM)
virsh domifaddr win-srv-2012-r2

# Método 3: escaneo de red
nmap -sn 192.168.122.0/24
```

La MAC de la VM es `b4:7a:f1:a7:0c:b4` — úsala para identificarla en la salida de los comandos anteriores.

---

## Asignar IP fija a la VM (recomendado)

Para evitar que la IP cambie al reiniciar, reserva la IP por MAC en libvirt:

```bash
virsh -c qemu:///system net-update default add ip-dhcp-host \
  '<host mac="b4:7a:f1:a7:0c:b4" name="win-srv-2012-r2" ip="192.168.122.10"/>' \
  --live --config
```

Esto hace que libvirt siempre asigne `192.168.122.10` a esa VM.

**No es necesario apagar la VM.** El flag `--live` aplica el cambio en caliente en la red.
Solo hace falta que la VM renueve su lease DHCP:

```powershell
# Desde PowerShell dentro de la VM (opción menos disruptiva)
ipconfig /release
ipconfig /renew
```

Si no tienes acceso a la consola de la VM, reiníciala desde el host:

```bash
virsh -c qemu:///system reboot win-srv-2012-r2
```

Para verificar que la VM tomó la nueva IP:

```bash
# Ver tabla ARP del bridge (no requiere ping)
ip neigh show dev virbr0

# Probar el puerto directamente
nc -zv 192.168.122.10 1100
```

---

## Verificar conectividad desde el host

```bash
# Ver si la VM está en la red (no requiere ping)
ip neigh show dev virbr0

# Probar que el puerto 1100 responde
nc -zv 192.168.122.10 1100

# O con curl
curl -v http://192.168.122.10:1100
```

---

## Verificar estado de la VM

```bash
# Ver si la VM está corriendo
virsh -c qemu:///system list --all

# Ver información general
virsh -c qemu:///system dominfo win-srv-2012-r2

# Iniciar la VM si está apagada
virsh -c qemu:///system start win-srv-2012-r2

# Apagar la VM de forma limpia
virsh -c qemu:///system shutdown win-srv-2012-r2
```

---

## Firewall en Windows Server 2012 R2

Si el servicio no responde, verificar que el firewall de Windows permite el puerto 1100.
Desde PowerShell **dentro de la VM**:

```powershell
# Ver si hay regla para el puerto 1100
Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' } |
  Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq 1100 }

# Crear regla de entrada si no existe
New-NetFirewallRule -DisplayName "WebApp 1100" -Direction Inbound `
  -Protocol TCP -LocalPort 1100 -Action Allow
```

---

## Troubleshooting

| Síntoma | Causa probable | Solución |
|---|---|---|
| `ping` no responde | VM apagada o sin red | `virsh list --all`, verificar estado |
| Puerto 1100 rechazado | Firewall Windows bloqueando | Agregar regla en Windows Firewall |
| IP diferente a `.243` | DHCP asignó nueva IP | Fijar IP por MAC (ver sección anterior) |
| `virbr0` sin IP | `libvirtd` no está corriendo | `systemctl start libvirtd` |
