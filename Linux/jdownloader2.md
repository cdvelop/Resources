# JDownloader 2 — Docker

Gestor de descargas ejecutado como contenedor Docker con interfaz web (noVNC).

**Configuración:** `~/Dev/Docker/App/JDownloader2/`
**Volumen de datos:** `~/Dev/Docker/Volumes/jdownloader2_volumes/`
**Descargas:** `~/Downloads/`

## Acceso

| Interfaz | URL |
|----------|-----|
| Web (noVNC) | http://localhost:5800 |
| MyJDownloader (remoto) | https://my.jdownloader.org |

## Levantar con Docker Compose

```bash
cd ~/Dev/Docker/App/JDownloader2/
docker compose up -d
```

## Detener

```bash
cd ~/Dev/Docker/App/JDownloader2/
docker compose down
```

## Credenciales

Guardadas en `~/Dev/Docker/App/JDownloader2/.env`:
- `MYJDOWNLOADER_EMAIL` — cuenta en my.jdownloader.org
- `MYJDOWNLOADER_PASSWORD` — contraseña de esa cuenta

## Seguridad

- Puerto `5800` restringido a `127.0.0.1` — solo accesible desde el host local.
- `WEB_AUTHENTICATION` disponible pero deshabilitado (red local de confianza).
  Para habilitarlo descomentar en `compose.yml`:
  ```yaml
  - WEB_AUTHENTICATION=1
  - WEB_AUTHENTICATION_USERNAME=usuario
  - WEB_AUTHENTICATION_PASSWORD=clave
  ```

## Actualizar imagen

```bash
cd ~/Dev/Docker/App/JDownloader2/
docker compose pull
docker compose up -d
```
