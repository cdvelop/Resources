# Apache2 en Debian

## Estado actual (2026-03-28)

Apache2 está instalado pero **deshabilitado** (2026-03-28).
No tenía uso activo — solo el sitio por defecto sin tráfico.

## Deshabilitar cuando no se usa

```bash
sudo systemctl stop apache2
sudo systemctl disable apache2
```

Para volver a habilitar:
```bash
sudo systemctl enable apache2
sudo systemctl start apache2
```

## Instalación

```bash
sudo apt install apache2
sudo systemctl enable apache2
sudo systemctl start apache2
```

## Comandos básicos

```bash
# Estado del servicio
sudo systemctl status apache2

# Ver sitios y configuración activa
sudo apache2ctl -S

# Verificar sintaxis de configuración
sudo apache2ctl configtest

# Recargar sin reiniciar (aplica cambios de config)
sudo systemctl reload apache2
```

## Estructura de directorios

```
/etc/apache2/
├── apache2.conf          # configuración principal
├── sites-available/      # sitios disponibles (no activos)
├── sites-enabled/        # sitios activos (symlinks)
├── mods-available/       # módulos disponibles
├── mods-enabled/         # módulos activos (symlinks)
└── conf-available/       # configuraciones extra
```

## Gestión de sitios

```bash
# Habilitar sitio
sudo a2ensite mi-sitio.conf
sudo systemctl reload apache2

# Deshabilitar sitio
sudo a2dissite mi-sitio.conf
sudo systemctl reload apache2

# Habilitar módulo (ej: mod_rewrite)
sudo a2enmod rewrite
sudo systemctl reload apache2
```

## Sitio virtual básico

```apache
# /etc/apache2/sites-available/mi-sitio.conf
<VirtualHost *:80>
    ServerName mi-sitio.local
    DocumentRoot /var/www/mi-sitio
    ErrorLog ${APACHE_LOG_DIR}/mi-sitio-error.log
    CustomLog ${APACHE_LOG_DIR}/mi-sitio-access.log combined
</VirtualHost>
```

## Logs

```bash
sudo tail -f /var/log/apache2/access.log
sudo tail -f /var/log/apache2/error.log
```
