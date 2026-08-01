# La suspensión no funciona — inhibidor huérfano de Nautilus

Fecha de diagnóstico: 2026-08-01
Hardware: Victus by HP Laptop 16-d0xxx
SO: Debian 13.6
Kernel: 6.12.96+deb13-amd64
GNOME Shell: 48.7 (Wayland)
systemd: 257 (257.13-1~deb13u1)
nautilus: 48.3-2

---

## Síntoma

Al pulsar **Suspender** en el menú de GNOME no ocurre absolutamente nada. Sin
diálogo, sin mensaje de error, sin pantalla apagada. El equipo sigue encendido
como si no se hubiera pulsado nada.

Cerrar la tapa tampoco suspende.

---

## Resumen

| Capa | Estado | Conclusión |
|------|--------|------------|
| Kernel / hardware | ✅ Correcto | 7 suspensiones exitosas, 0 fallos |
| Estados de sleep | ✅ Correcto | `deep` (S3) disponible y seleccionado |
| Configuración systemd | ✅ Correcto | `sleep.conf` y `logind.conf` sin overrides |
| polkit | ✅ Correcto | `allow_active=yes` para `login1.suspend` |
| **Sesión GNOME** | ❌ **Bloqueado** | **Inhibidor huérfano de Nautilus** |

**Causa raíz:** Nautilus mantenía registrado un inhibidor de sesión con motivo
`Copying Files` de una copia que había terminado o se interrumpió **3 días antes**.
Ese inhibidor propagaba un lock en modo `block` sobre `sleep` en logind, que
rechazaba toda petición de suspensión.

**Solución:** `nautilus -q`

---

## Diagnóstico paso a paso

### 1. Descartar el kernel

Lo primero es confirmar que el hardware y los drivers pueden suspender. Si esto
falla, el problema es otro completamente distinto.

```bash
cat /sys/power/state        # debe incluir "mem"
cat /sys/power/mem_sleep    # muestra el modo activo entre corchetes
for f in /sys/power/suspend_stats/*; do
  printf "%-22s %s\n" "$(basename $f):" "$(cat $f)"
done
```

Resultado obtenido:

```
freeze mem disk
s2idle [deep]

fail:                  0
failed_freeze:         0
failed_prepare:        0
failed_suspend:        0
last_failed_dev:
last_failed_errno:     0
last_failed_step:
success:               7
```

**7 éxitos y 0 fallos** en este arranque (uptime de 3 días). El kernel suspende
sin problema cuando se lo piden. Por lo tanto el fallo está por encima: nadie le
está pidiendo suspender.

> Nota: `suspend_stats` se reinicia en cada arranque. Si ves `success: 0` y
> `fail: N`, entonces sí es un problema de kernel/driver y este documento no
> aplica — mira `last_failed_dev` para saber qué dispositivo lo impide.

### 2. Buscar el error en el journal

```bash
journalctl -b -g "suspend|sleep|PM:" --no-pager | tail -60
```

Apareció este error, repetido en **cada intento** de suspender:

```
gnome-shell[1632]: Unhandled promise rejection. To suppress this warning, add an
error handler to your promise chain with .catch() or a try-catch block around
your await expression. Stack trace of the failed promise:
    @resource:///org/gnome/gjs/modules/core/overrides/Gio.js:192:20
    suspend@resource:///org/gnome/shell/misc/loginManager.js:199:21
    activateSuspend@resource:///org/gnome/shell/misc/systemActions.js:466:28
    _init/<@resource:///org/gnome/shell/ui/status/system.js:177:33
    activate@resource:///org/gnome/shell/ui/popupMenu.js:193:14
```

Las marcas de tiempo coincidían exactamente con cada pulsación del botón:
29 jul 22:46, 30 jul 10:35, 30 jul 23:09, 1 ago 15:03, 1 ago 15:04.

Interpretación: GNOME Shell llama a `Suspend()` por D-Bus contra logind, logind
lo rechaza, y GJS no maneja el rechazo de la promesa. **Por eso no aparece
ningún mensaje al usuario** — el error se pierde silenciosamente y la interfaz
no reacciona.

### 3. Listar los inhibidores de logind

Este es el comando decisivo:

```bash
systemd-inhibit --list
```

Lo relevante de la salida:

```
WHO             UID   USER   PID    COMM              WHAT              WHY                       MODE
gnome-session-b 1000  cesar  1589   gnome-session-b   shutdown:sleep    user session inhibited    block
NetworkManager  0     root   1148   NetworkManager    sleep             ...turn off networks      delay
UPower          0     root   3005   upowerd           sleep             Pause device polling      delay
GNOME Shell     1000  cesar  1632   gnome-shell       sleep             ...lock the screen        delay
```

**La distinción clave es la columna `MODE`:**

- `delay` — inofensivo. Solo pide unos segundos para prepararse antes de dormir
  (guardar estado, apagar radios, bloquear pantalla). Es completamente normal
  tener varios.
- `block` — **impide la suspensión por completo.** Este es el que hay que cazar.

Filtro directo:

```bash
systemd-inhibit --list | awk '$NF=="block"'
```

Había un `block` sobre `shutdown:sleep` de `gnome-session-binary` con el motivo
genérico `user session inhibited`. Ese motivo no dice qué aplicación lo pidió:
gnome-session actúa de intermediario y agrupa las peticiones de todas las apps
de la sesión.

### 4. Identificar la aplicación culpable

Para saber qué app está detrás hay que preguntarle directamente a gnome-session:

```bash
gdbus call --session --dest org.gnome.SessionManager \
  --object-path /org/gnome/SessionManager \
  --method org.gnome.SessionManager.GetInhibitors
```

Devolvió:

```
([objectpath '/org/gnome/SessionManager/Inhibitor72'],)
```

Y consultando ese objeto:

```bash
P=/org/gnome/SessionManager/Inhibitor72
gdbus call --session --dest org.gnome.SessionManager --object-path $P \
  --method org.gnome.SessionManager.Inhibitor.GetAppId
gdbus call --session --dest org.gnome.SessionManager --object-path $P \
  --method org.gnome.SessionManager.Inhibitor.GetReason
gdbus call --session --dest org.gnome.SessionManager --object-path $P \
  --method org.gnome.SessionManager.Inhibitor.GetFlags
```

```
('org.gnome.Nautilus',)
('Copying Files',)
(uint32 5,)
```

Culpable encontrado: **Nautilus**, motivo `Copying Files`, flags `5`.

Los flags son un campo de bits:

| Bit | Valor | Significado |
|-----|-------|-------------|
| 0 | 1 | Inhibe cerrar sesión (logout) |
| 1 | 2 | Inhibe cambio de usuario |
| 2 | 4 | **Inhibe suspender** |
| 3 | 8 | Inhibe el salvapantallas idle |
| 4 | 16 | Inhibe apagar/reiniciar |

`5 = 1 + 4` → inhibía cerrar sesión **y suspender**.

### 5. Verificar que la copia era fantasma

Antes de matar el proceso hay que confirmar que no hay una transferencia real en
curso — matarlo a mitad de una copia dejaría archivos incompletos.

```bash
ps -eo pid,etime,stat,%cpu,cmd | grep [n]autilus
for p in $(pgrep -f nautilus); do
  grep -E "^(read_bytes|write_bytes)" /proc/$p/io
  ls -l /proc/$p/fd | grep -vE "socket|anon_inode|pipe|/usr/|/dev/"
done
```

Evidencia de que no había copia alguna:

- Proceso levantado desde hacía **3 días y 6 horas** (`3-06:14:44`)
- **0.0% de CPU** y estado `Sl` (durmiendo, sin trabajo pendiente)
- **Ningún descriptor abierto** hacia un archivo origen o destino — solo las
  bases de datos internas (`gvfs-metadata`, `nautilus/tags/meta.db`)
- Solo **2.2 MB escritos en total** en tres días (`write_bytes: 2232320`)

Confirmado: lock huérfano. La copia terminó o se abortó días atrás y Nautilus
nunca liberó el inhibidor.

---

## Solución

```bash
nautilus -q
```

Cierra el servicio en segundo plano de Nautilus (`--gapplication-service`), lo
que libera el inhibidor. Se relanza solo la próxima vez que abras Archivos, sin
pérdida de configuración.

### Verificación

```bash
gdbus call --session --dest org.gnome.SessionManager \
  --object-path /org/gnome/SessionManager \
  --method org.gnome.SessionManager.GetInhibitors
# → (@ao [],)   ← lista vacía

systemd-inhibit --list | awk '$NF=="block"'
# → solo debe quedar gsd-media-keys con handle-power-key:handle-suspend-key:...
```

El `block` de `gsd-media-keys` sobre las teclas de encendido/suspensión es
**normal y esperado**: significa que GNOME gestiona esas teclas por su cuenta en
lugar de dejárselas a logind. No tiene nada que ver con este problema.

---

## Receta rápida para la próxima vez

```bash
# 1. ¿Hay algún bloqueo real?
systemd-inhibit --list | awk '$NF=="block"'

# 2. Si sale gnome-session-b con "sleep", ¿qué app es?
gdbus call --session --dest org.gnome.SessionManager \
  --object-path /org/gnome/SessionManager \
  --method org.gnome.SessionManager.GetInhibitors

# 3. Cerrar la app culpable (Nautilus en este caso)
nautilus -q

# 4. Escape de emergencia — ignora TODOS los inhibidores
systemctl suspend -i
```

> ⚠️ `systemctl suspend -i` fuerza la suspensión saltándose los inhibidores.
> Úsalo solo tras comprobar (paso 5 del diagnóstico) que no hay una copia o
> grabación real en marcha, o perderás datos.

---

## Otros sospechosos habituales

Si el `block` sobre `sleep` no viene de Nautilus, estos son los candidatos más
frecuentes:

| Aplicación | Motivo típico |
|------------|---------------|
| Nautilus / Archivos | `Copying Files` — copia colgada o huérfana |
| Chrome / Chromium / Firefox | Reproducción de vídeo o audio en una pestaña |
| GNOME Software / PackageKit | Instalación o actualización en curso |
| Transmission, qBittorrent | Descarga activa |
| Steam | Descarga o actualización de un juego |
| Disks (gnome-disks) | Formateo o imagen de disco en proceso |

En todos los casos el patrón es el mismo: cerrar la app libera el inhibidor.

---

## Limitación encontrada durante el diagnóstico

El usuario `cesar` no pertenece a los grupos `adm` ni `systemd-journal`, así que
`journalctl` solo muestra los mensajes del propio usuario:

```
Hint: You are currently not seeing messages from other users and the system.
      Users in groups 'adm', 'systemd-journal' can see all messages.
```

Esto oculta los mensajes de `systemd-logind` y del kernel, que son justo donde
suele estar la causa de los problemas de suspensión. `dmesg` tampoco es
accesible (`read kernel buffer failed: Operation not permitted`).

Para arreglarlo de forma permanente:

```bash
sudo usermod -aG systemd-journal cesar
# requiere cerrar y volver a abrir sesión
```

Mientras tanto, la alternativa es anteponer `sudo` a cada `journalctl`.

---

## Comandos de referencia

```bash
# Estados de suspensión soportados por el kernel
cat /sys/power/state
cat /sys/power/mem_sleep

# Estadísticas de suspensión (se reinician en cada arranque)
grep . /sys/power/suspend_stats/*

# ¿Puede logind suspender?
busctl call org.freedesktop.login1 /org/freedesktop/login1 \
  org.freedesktop.login1.Manager CanSuspend

# Dispositivos que pueden despertar el equipo
cat /proc/acpi/wakeup

# Configuración de systemd (vacías = valores por defecto)
grep -vE "^\s*#|^$" /etc/systemd/sleep.conf
grep -vE "^\s*#|^$" /etc/systemd/logind.conf

# Política polkit de suspensión
grep -A8 'action id="org.freedesktop.login1.suspend"' \
  /usr/share/polkit-1/actions/org.freedesktop.login1.policy

# Estado de la sesión (debe ser Active=yes para suspender sin contraseña)
loginctl list-sessions
loginctl show-session 1 -p Active -p State -p Type -p Seat
```

> Aviso sobre `CanSuspend`: devuelve `challenge` si lo ejecutas desde un proceso
> que no pertenece a la sesión gráfica activa (por ejemplo un terminal lanzado
> por un servicio de systemd `--user` o un agente automatizado). Eso **no**
> indica un fallo: polkit concede `yes` a los procesos de la sesión activa de
> `seat0`. Verifica siempre con `loginctl show-session <id> -p Active` antes de
> sacar conclusiones de ese valor.
