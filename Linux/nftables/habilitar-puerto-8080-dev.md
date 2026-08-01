# Habilitar el puerto 8080 en el firewall (Debian 13 / nftables)

Guía paso a paso para abrir el puerto 8080 en tu red local y poder probar
apps que corren en tu máquina (por ejemplo `http://192.168.1.X:8080`) desde
otro dispositivo de la misma red (celular, otra laptop, etc).

## 1. Identifica qué firewall estás usando

Debian puede traer `ufw`, `firewalld` o `nftables` puro. Antes de tocar nada,
confirma cuál está activo:

```bash
systemctl is-active ufw
systemctl is-active firewalld
systemctl is-active nftables
```

El que responda `active` es el que manda. En este equipo es **nftables**
(sin ufw ni firewalld instalados), así que el resto de la guía usa nftables.

> Si en tu caso `ufw` está activo, el proceso es distinto (`sudo ufw allow
> 8080/tcp`). Esta guía no aplica a ese caso.

## 2. Entiende dónde vive la configuración

En este equipo la configuración persistente está en:

```
/etc/nftables.conf
```

Ese archivo se carga automáticamente al iniciar el sistema (es un script
`#!/usr/sbin/nft -f`). Si editas las reglas "en caliente" con `nft add rule
...` pero no las agregas a este archivo, **se pierden al reiniciar**.

Revisa el archivo antes de tocarlo:

```bash
cat /etc/nftables.conf
```

Vas a ver algo así (resumido):

```
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;
        ct state established,related accept
        iif "lo" accept
        tcp dport 22 accept      # SSH
        tcp dport 80 accept      # HTTP local
        tcp dport 443 accept     # HTTPS local
        ...
    }
    ...
}
```

La `policy drop` en el chain `input` significa: "todo lo que no esté
explícitamente permitido, se bloquea". Por eso necesitas agregar una línea
para el 8080.

## 3. Agrega la regla para el puerto 8080

Opción rápida con `sed` (agrega la línea automáticamente después de una
regla existente):

```bash
sudo sed -i '/tcp dport 8200 accept    # MiniDLNA/a\    tcp dport 8080 accept    # Dev apps (LAN testing)' /etc/nftables.conf
```

> **¿Por qué aparece el puerto 8200 en este comando?** `sed -i '/patrón/a\...'`
> necesita una línea **existente y única** en el archivo para saber *después
> de cuál* insertar el texto nuevo (el flag `a` es de "append after match").
> En este equipo, `tcp dport 8200 accept # MiniDLNA` era la última regla de
> puerto dentro del `chain input`, justo antes de `iifname "virbr0" accept`,
> así que se usó como punto de anclaje. El 8200 no tiene ninguna relación
> funcional con el 8080 — es solo el marcador de texto donde se inserta la
> línea nueva. Si tu archivo no tiene esa línea (por ejemplo, no usas
> MiniDLNA), cambia el patrón por cualquier otra línea `tcp dport ... accept`
> que sí exista en tu configuración, o usa la opción manual de abajo.

Opción manual (más segura si eres nuevo con `sed`):

1. Abre el archivo con tu editor de confianza:
   ```bash
   sudo nano /etc/nftables.conf
   ```
2. Dentro del `chain input { ... }`, agrega una línea nueva junto a las
   demás reglas `tcp dport`:
   ```
   tcp dport 8080 accept    # Dev apps (LAN testing)
   ```
3. Guarda y cierra (`Ctrl+O`, `Enter`, `Ctrl+X` en nano).

## 4. Aplica el cambio

**Importante:** no uses `sudo nft flush ruleset` — eso borra TODAS las
tablas, incluidas las que usan Docker y libvirt para funcionar. Este
archivo ya está escrito para recargarse de forma segura:

```bash
sudo nft -f /etc/nftables.conf
```

Esto vuelve a leer el archivo completo y reemplaza solo la tabla
`inet filter` (gracias a la línea `destroy table inet filter` que tiene el
script al inicio), sin afectar otras tablas del sistema.

## 5. Verifica que la regla quedó activa

```bash
sudo nft list chain inet filter input | grep 8080
```

Deberías ver:

```
tcp dport 8080 accept    # Dev apps (LAN testing)
```

## 6. Prueba desde otro dispositivo en tu red local

1. Averigua la IP local de tu máquina Debian:
   ```bash
   ip addr show | grep "inet " | grep -v 127.0.0.1
   ```
2. Levanta tu app en el puerto 8080 (asegúrate de que escuche en
   `0.0.0.0:8080`, no solo en `127.0.0.1:8080`, si no otros dispositivos no
   podrán verla).
3. Desde otro dispositivo conectado a la misma red, abre en el navegador:
   ```
   http://<IP-de-tu-Debian>:8080
   ```

## 7. (Opcional) Revertir el cambio

Si luego quieres cerrar el puerto de nuevo:

1. Edita `/etc/nftables.conf` y elimina (o comenta con `#`) la línea:
   ```
   tcp dport 8080 accept    # Dev apps (LAN testing)
   ```
2. Vuelve a aplicar:
   ```bash
   sudo nft -f /etc/nftables.conf
   ```

## Notas de seguridad

- Esta regla abre el puerto 8080 a **toda tu red local**, no solo a un
  dispositivo específico. Es el mismo criterio que ya usan las reglas de
  80/443 en este archivo, así que es consistente con la configuración
  existente.
- No expone el puerto a internet — solo aplica a quien esté en tu misma
  red LAN (a menos que tu router tenga port forwarding configurado, que es
  un tema aparte).
- Si en algún momento quieres limitarlo a una sola IP o subred (por
  ejemplo `192.168.1.0/24`), la regla cambiaría a algo como:
  ```
  ip saddr 192.168.1.0/24 tcp dport 8080 accept
  ```
