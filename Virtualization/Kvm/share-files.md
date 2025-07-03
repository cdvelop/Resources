# Configurar el intercambio de archivos entre tu Debian 12 host y una VM KVM con Windows 10. Hay varias opciones disponibles:

## 1. SPICE con Drag & Drop (Similar a VirtualBox)

La forma más parecida a VirtualBox es usar SPICE con las herramientas de guest:

**En el host (Debian 12):**
```bash
# Instalar virt-viewer si no lo tienes
sudo apt install virt-viewer spice-client-gtk

# Conectar a la VM con SPICE
virt-viewer --connect qemu:///system nombre-de-tu-vm
```

**En la VM Windows 10:**
1. Descarga e instala **spice-guest-tools** desde: https://www.spice-space.org/download.html
2. Reinicia la VM
3. Después podrás arrastrar y soltar archivos entre host y VM

## 2. Carpeta Compartida con 9p/virtio-fs

**Modifica la configuración de tu VM:**
```bash
# Editar la VM
sudo virsh edit nombre-de-tu-vm
```

Añade esta sección dentro de `<devices>`:
```xml
<filesystem type='mount' accessmode='passthrough'>
  <source dir='/ruta/en/host/compartida'/>
  <target dir='shared'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
</filesystem>
```

**En Windows 10:**
La carpeta aparecerá como una unidad de red que puedes mapear.

## 3. Samba/CIFS (Red)

**En el host (Debian 12):**
```bash
# Instalar Samba
sudo apt install samba

# Crear carpeta compartida
mkdir -p /home/usuario/compartido

# Configurar Samba
sudo nano /etc/samba/smb.conf
```

Añade al final:
```ini
[compartido]
path = /home/usuario/compartido
browseable = yes
writable = yes
guest ok = yes
read only = no
```

```bash
# Reiniciar Samba
sudo systemctl restart smbd
```

**En Windows 10:**
- Abre el Explorador
- Ve a "Red" y busca tu host Debian
- O mapea directamente: `\\IP-del-host\compartido`

## 4. SSH/SFTP (Recomendado para archivos grandes)

**En el host:**
```bash
sudo apt install openssh-server
sudo systemctl enable --now ssh
```

**En Windows 10:**
- Usa WinSCP, FileZilla, o el explorador de archivos con `sftp://IP-del-host`

## Recomendación

Para la experiencia más parecida a VirtualBox, usa **SPICE con spice-guest-tools**. Es la opción que te dará drag & drop directo y mejor integración.

¿Quieres que te ayude a configurar alguna de estas opciones específicamente?