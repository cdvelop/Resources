# PostgreSQL — Seguridad y configuración de red

## Problema detectado (2026-03-28)

PostgreSQL estaba escuchando en **todas las interfaces de red** (`0.0.0.0:5432`),
exponiendo la base de datos a cualquier máquina en la red local y redes Docker.

```
# Estado inseguro:
LISTEN  0.0.0.0:5432
LISTEN     [::]:5432
```

## Diagnóstico

```bash
# Ver en qué interfaces escucha
sudo grep -E "^listen_addresses" /etc/postgresql/*/main/postgresql.conf

# Ver reglas de acceso por host
sudo grep -E "^host" /etc/postgresql/*/main/pg_hba.conf

# Confirmar puertos activos
ss -tlnp | grep 5432
```

## Fix automatizado (recomendado)

```bash
# Aplica el fix en instalación nativa + Docker
sudo bash ~/Dev/Resources/DataBase/secure-postgres.sh

# Solo instalación nativa
sudo bash ~/Dev/Resources/DataBase/secure-postgres.sh --native

# Solo contenedores Docker
sudo bash ~/Dev/Resources/DataBase/secure-postgres.sh --docker
```

El script:
- Hace backup del config antes de modificar
- Detecta y corrige `listen_addresses` en instalación nativa
- Detecta contenedores Docker con 5432 expuesto en 0.0.0.0 y ofrece recrearlos
- Verifica el resultado al final

---

## Fix manual — limitar a loopback

Editar `/etc/postgresql/*/main/postgresql.conf`:

```ini
# Cambiar esto:
listen_addresses = '*'

# Por esto (solo conexiones locales):
listen_addresses = 'localhost'
```

Si contenedores Docker necesitan acceso directo (sin socket Unix):
```ini
# Agregar la IP del bridge de Docker:
listen_addresses = 'localhost,172.17.0.1'
```

Aplicar:
```bash
sudo systemctl restart postgresql
ss -tlnp | grep 5432   # verificar que solo muestre 127.0.0.1
```

## Alternativa — acceso desde Docker via socket Unix

La forma más segura es montar el socket Unix en el contenedor, sin exponer puertos:

```yaml
# docker-compose.yml
services:
  app:
    volumes:
      - /var/run/postgresql:/var/run/postgresql
    environment:
      DATABASE_URL: postgresql:///mydb?host=/var/run/postgresql
```

## pg_hba.conf — control de acceso por host

```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```

Ejemplo seguro para desarrollo local:
```
# TYPE  DATABASE  USER  ADDRESS         METHOD
local   all       all                   peer
host    all       all   127.0.0.1/32    scram-sha-256
host    all       all   ::1/128         scram-sha-256
# Solo permitir desde redes Docker si es necesario:
host    all       all   172.17.0.0/16   scram-sha-256
```

No usar `trust` en entradas `host` — requiere siempre contraseña.

## Verificación

```bash
# Puertos activos de postgres
ss -tlnp | grep 5432

# Log de conexiones recientes
sudo tail -50 /var/log/postgresql/postgresql-*-main.log | grep "connection"
```
