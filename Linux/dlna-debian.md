# Cómo instalar y configurar MiniDLNA (ReadyMedia) en Debian

## Instalación automatizada
```bash
sudo bash -c '
apt update && apt install -y minidlna
'
```

---

## Ejemplo 1: Compartir una carpeta normal (por ejemplo, $HOME/Videos)
```bash
sudo bash -c '
DLNA_DIR="$HOME/Videos"  # Cambia esta variable a la carpeta que quieras compartir
mkdir -p "$DLNA_DIR"
chown -R minidlna:minidlna "$DLNA_DIR"
cp /etc/minidlna.conf /etc/minidlna.conf.bak # Backup del original
sed -i "s|^media_dir=.*|media_dir=V,$DLNA_DIR|" /etc/minidlna.conf
sed -i "s|^#friendly_name=.*|friendly_name=Servidor DLNA Debian|" /etc/minidlna.conf
sed -i "s|^#inotify=yes|inotify=yes|" /etc/minidlna.conf
systemctl restart minidlna && systemctl enable minidlna
minidlnad -R # Fuerza el escaneo inicial de archivos
'
```

---

## Ejemplo 2: Compartir carpeta local (por ejemplo, ~/Videos/DLNA)
```bash
sudo bash -c '
DLNA_LOCAL="/home/$USER/Videos/DLNA"  # Cambia esta variable a tu carpeta local
mkdir -p "$DLNA_LOCAL"

# Da permisos de acceso a las carpetas padre
chmod 755 /home/$USER
chmod 755 /home/$USER/Videos

# Añade el usuario actual al grupo minidlna
usermod -a -G minidlna $USER

# Configura permisos compartidos (usuario puede escribir, minidlna puede leer)
chown -R $USER:minidlna "$DLNA_LOCAL"
chmod -R 775 "$DLNA_LOCAL"

# Configura MiniDLNA
cp /etc/minidlna.conf /etc/minidlna.conf.bak # Backup del original
sed -i "s|^media_dir=.*|media_dir=V,$DLNA_LOCAL|" /etc/minidlna.conf
sed -i "s|^#friendly_name=.*|friendly_name=Servidor DLNA Local|" /etc/minidlna.conf
sed -i "s|^#inotify=yes|inotify=yes|" /etc/minidlna.conf

# Reinicia el servicio
minidlnad -R
systemctl restart minidlna && systemctl enable minidlna

echo "Nota: Reinicia tu sesión o ejecuta newgrp minidlna para aplicar el nuevo grupo"
'
```

---

## Puertos necesarios en el firewall (nftables ejemplo)

Agrega estas líneas a tu configuración de nftables:
```nft
udp dport 1900 accept    # DLNA SSDP (descubrimiento)
tcp dport 8200 accept    # MiniDLNA (puede variar según configuración)
```

---

## Verifica que el servicio esté activo
```bash
sudo systemctl status minidlna
```

---

Ahora tu televisor debería detectar el servidor DLNA con el nombre que configuraste y reproducir los videos de la carpeta o disco que elegiste.

---

## Solución de problemas: MiniDLNA y discos USB

### revisar logs
```bash
sudo minidlnad -R && sleep 5 && sudo journalctl -u minidlna | grep -iE 'scann|added|inotify|db|media' | tail -30
```
Si tu televisor ve carpetas vacías o no muestra el contenido correcto:

1. Verifica que el disco esté montado en la ruta configurada:
   ```bash
   ls /media/cesar/movie
   ```
2. Monta el disco USB con permisos para minidlna (reemplaza /dev/sdX1 por tu dispositivo real):
   ```bash
   sudo umount /media/cesar/movie
   sudo mount -t ntfs-3g -o uid=$(id -u minidlna),gid=$(id -g minidlna) /dev/sdX1 /media/cesar/movie
   ```
3. Asegúrate de que la ruta en `/etc/minidlna.conf` coincide exactamente con el punto de montaje.
4. Fuerza el reescaneo de la base de datos y reinicia MiniDLNA:
   ```bash
   sudo minidlnad -R
   sudo systemctl restart minidlna
   ```
5. Espera unos minutos y vuelve a buscar desde el televisor.

Si el problema persiste, revisa los logs con:
```bash
sudo journalctl -u minidlna
```

---

## Ejemplo extra: MiniDLNA solo mientras la terminal esté abierta

Si quieres que MiniDLNA solo funcione mientras tengas una terminal abierta (sin dejar demonios en segundo plano), usa este script:

```bash
sudo ~/Dev/Resources/Linux/minidlna-standalone.sh
```

El servidor DLNA se apagará automáticamente al cerrar la terminal.

El script es:
```bash
#!/bin/bash
# Script para iniciar MiniDLNA en primer plano y detenerlo al cerrar la terminal

# Opcional: fuerza reescaneo
minidlnad -R

# Inicia MiniDLNA en primer plano (no como demonio)
exec minidlnad -f /etc/minidlna.conf -d
```
