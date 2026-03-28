# Reglas nftables

## Laptop de desarrollo (Docker + libvirt + SMB + DLNA)

Configuración base del archivo `nftables.conf`. Ver el archivo para el contenido completo.

**Puertos abiertos en `input`:**

| Puerto | Protocolo | Uso |
|--------|-----------|-----|
| 22 | TCP | SSH |
| 80 | TCP | HTTP local |
| 443 | TCP | HTTPS local |
| 445 | TCP | SMB (Windows modernos) |
| 139 | TCP | SMB NetBIOS (Windows antiguos) |
| 137 | UDP | NetBIOS Name Service |
| 138 | UDP | NetBIOS Datagram Service |
| 1900 | UDP | DLNA SSDP / UPnP discovery |
| 8200 | TCP | MiniDLNA |

**Reglas `forward` para Docker:**
- `iifname "docker0"` / `oifname "docker0"` — red por defecto de Docker
- `iifname "br-*"` / `oifname "br-*"` — redes bridge personalizadas (`docker network create`)

> Usar siempre `iifname`/`oifname` (match por nombre) y NO `iif`/`oif` (match por índice).
> Con `iif`/`oif`, si `docker0` no existe al momento del boot, nftables falla con exit 1.

---

## Errores comunes

### Reglas duplicadas al recargar

**Síntoma:** `nft list ruleset` muestra cada regla dos veces.

**Causa:** El config no tiene `destroy table inet filter` al inicio. Cada recarga agrega
las reglas encima de las existentes.

**Solución:** Asegurarse que `/etc/nftables.conf` empiece con:
```
destroy table inet filter
```
No usar `flush ruleset` — borra las tablas de Docker y libvirt.

### nftables.service falla en el boot (exit code 1)

**Síntoma:**
```
Process: ExecStart=/usr/sbin/nft -f /etc/nftables.conf → exit-code 1
```

**Causa:** El config usa `iif "docker0"` o `oif "docker0"`. Al boot, `docker0` no existe
todavía, nft no puede resolver el índice y falla.

**Solución:** Reemplazar en la chain `forward`:
```
# MAL — requiere que docker0 exista al cargar
iif "docker0" accept
oif "docker0" accept

# BIEN — match por nombre, funciona aunque docker0 no exista aún
iifname "docker0" accept
oifname "docker0" accept
```

### No guardar nft list ruleset como config

```bash
# MAL — guarda TODAS las tablas incluyendo Docker y libvirt
nft list ruleset > /etc/nftables.conf

# BIEN — solo listar la tabla propia para revisar
nft list table inet filter
```
Al arrancar, nftables intentaría cargar las tablas de Docker/libvirt desde el config,
pero esas herramientas las gestionan dinámicamente → conflictos y errores.

---

## Servidor web (solo SSH + HTTPS)

```nft
destroy table inet filter

table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;
        ct state established,related accept
        iif "lo" accept
        tcp dport 22 accept
        tcp dport 443 accept
    }
    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }
    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
```
