# Errores post-upgrade Debian 12 → 13

Fecha de diagnóstico: 2026-03-28
Kernel: `6.12.74+deb13+1-amd64`
Host: `cs-laptop`

---

## Resumen de problemas

| # | Servicio | Severidad | Estado |
|---|----------|-----------|--------|
| 1 | `nftables.service` | **Alta** — firewall no arranca | ✅ Resuelto |
| 2 | `localsearch-3.service` | Media — indexador de archivos falla | ✅ Resuelto |
| 3 | GNOME session scopes | Baja — errores de sesión cosméticos | Conocido / No requiere acción |

---

## 1. nftables.service — FAILED (prioridad alta)

### Síntoma
El firewall falla al arrancar:
```
Process: ExecStart=/usr/sbin/nft -f /etc/nftables.conf → exit-code 1
```

### Diagnóstico
El binario `/usr/sbin/nft` existe (paquete `nftables 1.1.3-1` instalado), pero la carga del ruleset falla.
La config en `/etc/nftables.conf` usa sintaxis con wildcards de Docker (`br-*`) que puede haber cambiado en nftables 1.1.x.

### Verificar
```bash
sudo nft -c -f /etc/nftables.conf
```

### Posibles causas (Debian 13)
- Sintaxis `iifname "br-*"` requiere soporte de wildcards en kernel — verificar que el módulo `nft_fib_inet` esté activo.
- En nftables 1.1.x algunos metaselectors cambiaron.

### Causa confirmada
El config tenía `iif "docker0"` y `oif "docker0"` (match por índice de interfaz).
Al boot, `docker0` no existe todavía → nft falla con exit 1.
Además faltaba `flush table inet filter` al inicio, causando reglas duplicadas en cada recarga.

### Solución aplicada
Editar `/etc/nftables.conf`:
1. Agregar `flush table inet filter` al inicio (antes de `table inet filter {`)
2. Reemplazar `iif "docker0"` → `iifname "docker0"`
3. Reemplazar `oif "docker0"` → `oifname "docker0"`

Ver configuración correcta en `~/Dev/Resources/Linux/nftables/nftables.conf`.

Para aplicar:
```bash
sudo tee /etc/nftables.conf < ~/Dev/Resources/Linux/nftables/nftables.conf
sudo systemctl restart nftables
sudo systemctl status nftables
```

---

## 2. localsearch-3.service — FAILED (usuario)

### Síntoma
```
localsearch-3.service: Main process exited, code=exited, status=1/FAILURE
```
El servicio falla múltiples veces al inicio de sesión GNOME.

### Diagnóstico
```bash
dpkg -l localsearch
# → un  localsearch  <none>  (no description available)
```
El paquete **no está instalado**. En Debian 13, GNOME renombró `tracker-miner-fs` a `localsearch`. El upgrade no instaló el nuevo paquete automáticamente.

### Decisión: deshabilitar el servicio

`localsearch` es el indexador de archivos de GNOME (antes `tracker-miner-fs`).
Sirve para búsqueda visual desde Nautilus o GNOME Shell.

**Motivos para deshabilitarlo en un perfil de desarrollo:**
- Indexa continuamente → picos de CPU e I/O en proyectos con muchos archivos (`node_modules`, cachés Go, imágenes Docker, etc.)
- La búsqueda de archivos en desarrollo se hace con herramientas de terminal (`fd`, `rg`, `find`) que son más precisas y rápidas
- No aporta valor práctico en este flujo de trabajo

```bash
# Sin sudo — es un servicio de sesión de usuario, no del sistema
# --user  → opera sobre el systemd de la sesión del usuario (no el sistema)
# mask    → crea un enlace simbólico de la unidad a /dev/null, impidiendo
#           que arranque de cualquier forma: manual, automática o por dependencia
#           Es más fuerte que disable: disable solo evita el arranque automático
systemctl --user mask localsearch-3.service
```

Para revertir si alguna vez se necesita:
```bash
# Sin sudo
systemctl --user unmask localsearch-3.service
systemctl --user start localsearch-3.service
```

---

## 3. GNOME Session Scopes — Failed to start (cosmético)

### Síntoma
```
Failed to start app-gnome-gnome\x2dkeyring\x2dsecrets-3341.scope
Failed to start app-gnome-gnome\x2dkeyring\x2dssh-3344.scope
Failed to start app-gnome-xdg\x2duser\x2ddirs-3359.scope
Failed to start app-gnome-user\x2ddirs\x2dupdate\x2dgtk-3545.scope
```

### Diagnóstico
Errores transitorios del gestor de sesión de GNOME al arrancar scopes de aplicaciones. En Debian 13 (GNOME 47/48) cambió el sistema de tracking de procesos de sesión. Estos errores **no impiden que las apps funcionen** — son race conditions resueltas internamente.

### Estado
Conocido en Debian 13. Si gnome-keyring y xdg-user-dirs funcionan correctamente, estos errores pueden ignorarse. Ver bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1068014

---

## 4. Errores menores adicionales

### wireplumber — UPower DBus timing
```
wireplumber: Failed to get percentage from UPower: org.freedesktop.DBus.Error.NameHasNoOwner
```
Race condition al inicio de sesión: wireplumber intenta conectar a UPower antes de que el daemon esté en el bus D-Bus. UPower arranca correctamente después. **No requiere acción.**

### gsd-usb-protect — USBGuard no instalado
```
gsd-usb-protect: Failed to fetch USBGuard parameters: ...ServiceUnknown
```
USBGuard no está instalado. gnome-settings-daemon intenta conectarse pero falla gracefully. **No requiere acción.**

### gsd-media-keys — keybindings fallidas
```
Failed to grab accelerator for: rotate-video-lock, hibernate, playback-repeat, screensaver, playback-random
```
Algunos atajos de teclado multimedia no pudieron registrarse (probablemente conflicto con otra app o el compositor). Menor.

---

## Comandos de diagnóstico útiles

```bash
# Ver todos los errores del boot actual:
journalctl -b 0 --priority=err --no-pager

# Ver unidades fallidas:
systemctl --failed

# Ver logs de nftables:
sudo journalctl -u nftables -n 30

# Ver logs de localsearch:
journalctl --user -u localsearch-3.service -n 30
```
