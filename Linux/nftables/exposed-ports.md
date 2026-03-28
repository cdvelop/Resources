# Puertos expuestos — cs-laptop

Última revisión: 2026-03-28

Comando para ver estado actual:
```bash
ss -tlnp   # TCP
ss -ulnp   # UDP
```

---

## TCP — expuestos en red local (0.0.0.0 / ::)

| Puerto | Servicio | Proceso | Expuesto a | Estado |
|--------|----------|---------|------------|--------|
| 80 | HTTP | apache2 | — | ✅ Deshabilitado 2026-03-28 |
| 139 | SMB NetBIOS | smbd | Red local | ✅ Intencional |
| 445 | SMB | smbd | Red local | ✅ Intencional |
| 1716 | KDE Connect | kdeconnectd | Red local | ✅ Intencional |
| 5432 | PostgreSQL | postgres | localhost | ✅ Resuelto 2026-03-28 |
| 5800 | noVNC (jdownloader2) | Docker | localhost | ✅ Resuelto 2026-03-28 |
| 8200 | MiniDLNA | minidlna | Red local | ✅ Intencional |

## TCP — solo loopback (seguros) ✅

| Puerto | Servicio | Notas |
|--------|----------|-------|
| 25 | exim4 | Correo local del sistema |
| 11434 | Ollama | API LLM local |
| 45551 / 57115 | VS Code | IPC interno |
| 53 | libvirt DNS | Solo red 192.168.122.x |

---

## Reglas del firewall relacionadas

El firewall (`/etc/nftables.conf`) controla qué tráfico entra.
Ver configuración completa en `nftables.conf`.

Puertos abiertos en la chain `input`:

```
tcp dport 22    # SSH
tcp dport 80    # HTTP (abrir solo si Apache está activo)
tcp dport 443   # HTTPS
tcp dport 445   # SMB
tcp dport 139   # SMB NetBIOS
udp dport 137   # NetBIOS Name Service
udp dport 138   # NetBIOS Datagram
udp dport 1900  # DLNA SSDP
tcp dport 8200  # MiniDLNA
```

**Nota:** El firewall limita el acceso entrante desde la red, pero PostgreSQL
en `0.0.0.0:5432` sigue accesible desde dentro de la red local aunque nftables
no tenga una regla de apertura explícita para el puerto 5432 — la política
`established,related accept` permite conexiones iniciadas desde la LAN si
el tráfico forward lo permite. **Mejor práctica: limitar PostgreSQL a localhost
a nivel de configuración del servicio.**

---

## Acciones pendientes

```bash
# 1. Verificar que PostgreSQL escucha solo en localhost
ss -tlnp | grep 5432

# 2. Verificar binding del contenedor jdownloader2
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep 5800

# 3. Verificar que apache2 está deshabilitado
systemctl is-active apache2
```
