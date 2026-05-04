# QEMU/KVM — VMs sin red (DHCP no responde, sin internet)

## Síntomas

- VM tiene la NIC conectada a la red `default` de libvirt (NAT, `virbr0`/`192.168.122.0/24`)
- Windows muestra IP APIPA (`169.254.x.x`) → DHCP no obtiene respuesta
- Con IP estática tampoco hay ping al gateway `192.168.122.1`
- `tcpdump -i virbr0 port 67 or 68` muestra `DHCP DISCOVER` saliendo de la VM, pero **ningún OFFER** del host

## Causa raíz

**Conflicto entre la tabla nftables del usuario y las tablas que libvirt agrega vía iptables-nft.**

En este host coexisten dos tablas en el mismo hook:

| Tabla | Origen | Política |
|---|---|---|
| `inet filter` | `/etc/nftables.conf` (configurada por el usuario) | `policy drop` |
| `ip filter` (LIBVIRT_INP, LIBVIRT_FWO, etc.) | libvirt (vía iptables-nft) | accept para virbr0 |

En nftables, **si cualquier tabla emite drop, el paquete se descarta** — no importa que otra tabla lo acepte. La tabla `inet filter` del usuario tenía reglas para SSH, SMB, Docker y `br-*`, pero **ninguna para `virbr0`**, así que las respuestas DHCP y el tráfico forward de las VMs caían en la `policy drop`.

Síntoma característico: Docker funciona (sí tiene reglas para `docker0` y `br-*`), libvirt no.

## Solución

Editar `/etc/nftables.conf` y agregar reglas para `virbr0` en `input` y `forward`:

```nft
chain input {
    ...
    iifname "virbr0" accept    # libvirt NAT bridge (DHCP, DNS desde VMs)
}
chain forward {
    ...
    iifname "virbr0" accept    # VMs → internet
    oifname "virbr0" accept    # internet → VMs (ct related ya cubre la mayor parte)
}
```

Aplicar y persistir:
```bash
sudo systemctl reload nftables   # o: sudo nft -f /etc/nftables.conf
sudo systemctl enable nftables    # ya estaba enabled, confirmar
```

Tras esto:
- DHCP responde: `cat /var/lib/libvirt/dnsmasq/default.leases` muestra el lease
- VM hace ping al gateway y a internet sin tocar ninguna config del lado del guest

---

## Diagnóstico paso a paso (cómo se llegó a la causa)

### 1. IP forwarding
```bash
cat /proc/sys/net/ipv4/ip_forward
```
`1` ✅

### 2. Bridge y dnsmasq vivos
```bash
ip addr show virbr0                  # UP, 192.168.122.1/24
pgrep -a dnsmasq                     # corriendo con default.conf
sudo ss -ulnp | grep 67              # bind a virbr0:67
```
Todo OK ✅ — descarta config de libvirt.

### 3. tcpdump confirma que DISCOVER llega pero no hay OFFER
```bash
sudo tcpdump -i virbr0 -n port 67 or port 68
```
Solo se ven `BOOTP/DHCP, Discover` repetidos cada 3-15s sin respuesta del host.

### 4. iptables-nft muestra reglas LIBVIRT correctas
```bash
sudo iptables -L LIBVIRT_INP -n -v
sudo iptables -L LIBVIRT_OUT -n -v
sudo iptables -t nat -L LIBVIRT_PRT -n -v
```
- `LIBVIRT_INP` UDP/67: 9 paquetes accept ✅
- `LIBVIRT_PRT`: MASQUERADE configurado ✅

A esta altura todo lo "tradicional" estaba OK pero las respuestas no salían. Esto descarta firewall iptables-nft, AppArmor, capabilities de dnsmasq, `bridge-nf-call-iptables` (módulo `br_netfilter` ni siquiera estaba cargado).

### 5. nftables ruleset revela la tabla del usuario
```bash
sudo nft list ruleset
```
Aparece `table inet filter` con `policy drop` y reglas explícitas solo para `docker0` y `br-*` — sin `virbr0`. Ese fue el momento eureka.

---

## Notas adicionales del entorno

- OS host: Debian Bookworm (Linux 6.12)
- Virtualización: KVM + libvirt
- Coexisten Docker + libvirt + SMB + DLNA (todos tocan iptables/nftables)
- libvirt usa iptables-nft (tabla `ip filter`), el usuario administra su propia `table inet filter`
- Modelo NIC de la VM: `e1000e` (irrelevante para este caso)

## Trampas que NO eran el problema (descartadas durante el diagnóstico)

| Sospechoso | Resultado | Comentario |
|---|---|---|
| Driver e1000e en Windows | OK — Intel 82574L detectado | `ipconfig /all` muestra adapter Connected con 169.254.x.x |
| `bridge-nf-call-iptables` | Módulo no cargado | `/proc/sys/net/bridge/` no existe |
| AppArmor bloqueando dnsmasq | `unconfined` | `cat /proc/<pid>/attr/current` |
| Capabilities de dnsmasq | `0x3400` = NET_BIND + NET_ADMIN + NET_RAW ✅ | Suficientes para DHCP raw socket |
| Cadenas DOCKER-USER bloqueando | Vacía | Docker no interfiere directamente con FORWARD libvirt |
| `virsh net-destroy` con VM corriendo | **¡Sí desconecta la VM!** | Genera `vnet` huérfano. Apagar VM antes de tocar la red. |

## Lección operacional

> **Si en este host agregas un nuevo bridge (libvirt, contenedores, etc.), debes agregarle reglas explícitas en `/etc/nftables.conf` (input y forward).** La policy es `drop` y las tablas que agreguen otros servicios (libvirt vía iptables-nft) no anulan ese drop.
