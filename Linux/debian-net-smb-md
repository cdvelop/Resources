# SMB (Server Message Block) 
es un protocolo de red utilizado para compartir archivos, impresoras y otros recursos entre computadoras, especialmente en redes Windows, pero también es compatible con Linux mediante Samba.


# Cómo habilitar SMB en Debian 12 para compartir archivos

Sigue estos pasos en orden. Si todo funciona correctamente, no deberías necesitar la sección de resolución de problemas al final.

## 1. Instala Samba (solo pedirá la contraseña una vez):
```bash
sudo bash -c 'apt update && apt install -y samba'
```

## 2. Crea una carpeta para compartir, por ejemplo:
```bash
mkdir -p ~/Share
chmod 0777 ~/Share
```


> ⚠️ **Importante:** No crees el archivo `/etc/samba/smb.conf` manualmente antes de instalar Samba. El instalador lo genera automáticamente.


## 3. Agrega la configuración de Samba automáticamente (usando tu usuario actual y la carpeta ~/Share):
```bash
echo -e "[Compartida]\n   path = $HOME/Share\n   browseable = yes\n   read only = no\n   guest ok = yes" | sudo tee -a /etc/samba/smb.conf
```
Esto agregará la configuración al final del archivo generado por el instalador.

---

**Si la instalación de Samba se interrumpe o dpkg queda bloqueado:**

1. Ejecuta para reparar el sistema de paquetes:
```bash
sudo dpkg --configure -a
```
2. Si es necesario, elimina el archivo de bloqueo:
```bash
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
```
3. Reintenta la instalación:
```bash
sudo apt install -y --reinstall samba
```


## 4. Reinicia el servicio Samba:
```bash
sudo systemctl restart smbd
```


## 5. (Opcional) Permite el tráfico SMB en el firewall:
```bash
sudo ufw allow samba
```


Ahora, otros equipos en la red podrán acceder a la carpeta compartida usando la dirección IP de tu Debian, por ejemplo: `\\IP_DE_TU_DEBIAN\Compartida` desde Windows o `smb://IP_DE_TU_DEBIAN/Compartida` desde Linux.

---

## Resolución de problemas y errores frecuentes

Si durante la instalación ves un error como:
> E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.

Ejecuta primero este comando para reparar el sistema de paquetes antes de continuar:
```bash
sudo dpkg --configure -a
```

Si es necesario, elimina el archivo de bloqueo:
```bash
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
```

Luego, reintenta la instalación:
```bash
sudo apt install -y --reinstall samba
```

