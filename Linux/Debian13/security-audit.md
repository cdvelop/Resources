# Auditoría de seguridad — Debian 13 (cs-laptop)

Fecha: 2026-03-28

Cada tema está documentado en su dominio correspondiente.
Este archivo es el índice de hallazgos y su estado.

---

## Estado general

| # | Hallazgo | Severidad | Estado | Referencia |
|---|----------|-----------|--------|------------|
| 1 | PostgreSQL expuesto en todas las interfaces | 🔴 Alta | ✅ Resuelto 2026-03-28 | [DataBase/postgres-security.md](../../DataBase/postgres-security.md) |
| 2 | jdownloader2 (noVNC) puerto 5800 expuesto | ⚠️ Media | ✅ Resuelto 2026-03-28 | [nftables/exposed-ports.md](../nftables/exposed-ports.md) |
| 3 | Apache2 activo sin uso | ⚠️ Media | ✅ Resuelto 2026-03-28 | [Linux/apache2.md](../apache2.md) |
| 4 | exim4 activo (solo loopback) | ℹ️ Baja | ✅ Resuelto 2026-03-28 | ver abajo |
| 5 | winbind activo (¿necesario?) | ℹ️ Baja | ✅ Resuelto 2026-03-28 | ver abajo |
| 6 | ModemManager activo (¿hay modem?) | ℹ️ Baja | ✅ Resuelto 2026-03-28 | ver abajo |
| 7 | Firewall nftables | ✅ OK | Resuelto | [nftables/nftables.conf](../nftables/nftables.conf) |

---

## Puertos expuestos

Documentado en: [nftables/exposed-ports.md](../nftables/exposed-ports.md)

---

## PostgreSQL — puerto 5432

Escuchando en `0.0.0.0:5432` — expuesto a toda la red local.
Documentado y fix en: [DataBase/postgres-security.md](../../DataBase/postgres-security.md)

---

## Apache2 — puerto 80

Activo sin uso. Solo tiene el sitio por defecto (`000-default.conf`).
Documentado en: [Linux/apache2.md](../apache2.md)

```bash
# Deshabilitar
sudo systemctl stop apache2 && sudo systemctl disable apache2
```

---

## Servicios menores a revisar

### exim4 — servidor de correo ✅ Deshabilitado 2026-03-28
Solo escuchaba en loopback — sin riesgo de red.
Deshabilitado por no tener uso activo. No desinstalado — es dependencia suave
de varios paquetes Debian y desinstalarlo puede generar conflictos.

```bash
# Comando usado para deshabilitar:
sudo systemctl stop exim4 && sudo systemctl disable exim4

# Rehabilitar si se necesitan notificaciones del sistema (cron, etc.):
sudo systemctl enable --now exim4
```

### winbind — integración con dominios Windows/AD ✅ Deshabilitado 2026-03-28

**¿Qué hace winbind?**
Permite que Linux autentique usuarios contra un servidor **Active Directory**
corporativo (Windows Domain Controller). Solo útil en entornos empresariales
donde el equipo pertenece a un dominio Windows.

**¿Tiene que ver con Samba?** Samba (smbd/nmbd) para compartir carpetas en
red local funciona perfectamente **sin winbind**. Son independientes.

**¿Tiene que ver con Remote Desktop (RDP)?** No. RDP es un protocolo
distinto (puerto 3389). Para conectarte por RDP a máquinas Windows o Linux
se usa un cliente como **Remmina** — no requiere winbind ni Samba.

Estaba activo sin dominio configurado (`net ads info` → no domain).
Consumía 27MB RAM sin función.

```bash
# Comando usado para deshabilitar:
sudo systemctl stop winbind && sudo systemctl disable winbind

# Rehabilitar solo si el equipo se une a un dominio Windows/AD corporativo:
sudo systemctl enable --now winbind
```

### ModemManager — gestión de modems 3G/4G ✅ Deshabilitado 2026-03-28

**¿Qué hace?** Gestiona modems móviles USB/PCIe (3G/4G/LTE). No tiene relación
con el WiFi integrado — ese lo maneja NetworkManager directamente.
`mmcli -L` confirmó que no hay ningún modem detectado en el sistema.
Consumía 8MB RAM sin función.

```bash
# Comando usado para deshabilitar:
sudo systemctl stop ModemManager && sudo systemctl disable ModemManager

# Rehabilitar si se conecta un modem USB 4G/LTE externo:
sudo systemctl enable --now ModemManager
```

---

## Herramientas de auditoría

| Herramienta | Propósito | Documento |
|-------------|-----------|-----------|
| lynis | Auditoría general del sistema | [security/lynis.md](../security/lynis.md) |
| rkhunter | Detección de rootkits y binarios modificados | [security/rkhunter.md](../security/rkhunter.md) |
| debsums | Integridad de paquetes instalados | `sudo apt install debsums && sudo debsums -c` |

```bash
# Revisión rápida periódica
systemctl --failed
ss -tlnp
systemctl list-units --type=service --state=running --no-pager
```

---

## Revisión periódica

```bash
# Estado del firewall
sudo nft list table inet filter

# Puertos escuchando
ss -tlnp && ss -ulnp

# Unidades fallidas
systemctl --failed
```
