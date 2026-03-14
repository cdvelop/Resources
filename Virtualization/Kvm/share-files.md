# Compartir archivos entre Debian 12 (host) y Windows 10 (VM KVM)

## Resumen comparativo

| Opcion        | Facilidad | Rendimiento | Persistente | Requiere red |
|---------------|-----------|-------------|-------------|--------------|
| Samba/CIFS    | Alta      | Alto        | Si          | Si (virtual) |
| SPICE D&D     | Alta      | Bajo        | No          | No           |
| SSH/SFTP      | Media     | Alto        | Si          | Si (virtual) |
| 9p/virtio-fs  | Baja      | Alto        | Si          | No           |

---

## Opcion recomendada: Samba/CIFS

La mejor opcion para Windows 10 en KVM. Windows tiene soporte nativo para SMB, se integra directo en el Explorador de archivos como una unidad de red, y el rendimiento es bueno para cualquier tamano de archivo.

### Paso 1: Instalar y configurar Samba en el host

```bash
sudo apt install samba
mkdir -p /home/<user_name>/Share
```

Editar `/etc/samba/smb.conf` y agregar al final:

```ini
# [nombre_recurso] → este nombre es el que se usa en Windows: \\IP\nombre_recurso
[Share]
path = /home/<user_name>/Share
browseable = yes
writable = yes
guest ok = yes
read only = no
```

Se pueden agregar multiples recursos, cada uno con su propio bloque:

```ini
# Segundo recurso de ejemplo (puede ser cualquier directorio del sistema)
[Datos]
path = /opt/datos
browseable = yes
writable = yes
guest ok = yes
read only = no
```

Cada bloque `[nombre]` genera una ruta independiente en Windows: `\\IP\Share`, `\\IP\Datos`, etc.

> Si el path esta fuera de /home, asegurarse de que el usuario tenga permisos:
> `sudo chown <user_name>:<user_name> /opt/datos`

```bash
# Crear usuario Samba (puede tener contrasena distinta a la de Linux)
sudo smbpasswd -a <user_name>

sudo systemctl restart smbd
sudo systemctl enable smbd
```

### Paso 2: Acceder desde Windows 10

1. Abrir el Explorador de archivos
2. En la barra de direcciones escribir: `\\IP-del-host\nombre_recurso`
3. (Opcional) Click derecho > "Conectar a unidad de red" para que sea permanente

Para obtener la IP del host en la red virtual:
```bash
ip addr show virbr0
# Buscar la linea "inet" → ejemplo: inet 192.168.122.1/24
# La IP del host es 192.168.122.1
# En Windows escribir: \\192.168.122.1\nombre_recurso
```
> Nota: si `virbr0` aparece como `DOWN` o `NO-CARRIER` es normal cuando la VM esta apagada. La IP sigue siendo valida y funcionara al encender la VM.

---

## Alternativas

### SPICE con Drag & Drop

Util para transferencias ocasionales arrastrando archivos. No sirve como carpeta compartida persistente.

**Host:**
```bash
sudo apt install virt-viewer spice-client-gtk
virt-viewer --connect qemu:///system nombre-de-tu-vm
```

**Windows 10:** Instalar [spice-guest-tools](https://www.spice-space.org/download.html) y reiniciar la VM.

### SSH/SFTP

Buena opcion si ya tienes SSH activo. Requiere un cliente en Windows (WinSCP o FileZilla).

**Host:**
```bash
sudo apt install openssh-server
sudo systemctl enable --now ssh
```

**Windows 10:** Conectar con WinSCP o FileZilla a la IP del host.

### 9p/virtio-fs

Monta una carpeta del host directamente en la VM. Soporte limitado en Windows (requiere drivers adicionales que pueden dar problemas). No recomendado para Windows.

```bash
sudo virsh edit nombre-de-tu-vm
```

Agregar dentro de `<devices>`:
```xml
<filesystem type='mount' accessmode='passthrough'>
  <source dir='/ruta/en/host/compartida'/>
  <target dir='shared'/>
</filesystem>
```