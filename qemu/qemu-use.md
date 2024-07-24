## Uso básico

1. Abre el símbolo del sistema (cmd.exe) o PowerShell.
2. Navega al directorio donde se instaló QEMU, generalmente `C:\Program Files\qemu`.
3. Para ejecutar una máquina virtual, utiliza el comando `qemu-system-x86_64.exe` seguido de las opciones necesarias. Por ejemplo:


qemu-system-x86_64.exe -hda windows.img


Este comando ejecutará una máquina virtual utilizando el archivo de imagen `windows.img` como disco duro.

4. Puedes utilizar varias opciones para configurar la máquina virtual, como asignar memoria RAM, habilitar la aceleración de hardware, etc. Consulta la documentación de QEMU para obtener más información sobre las opciones disponibles.

## Administración de imágenes de disco

QEMU puede trabajar con diferentes formatos de imagen de disco, como QCOW2, VDI, VMDK, etc. Puedes crear, convertir y administrar imágenes de disco utilizando las herramientas proporcionadas por QEMU, como `qemu-img`.

Por ejemplo, para crear una nueva imagen de disco QCOW2 de 10 GB:

```bash
qemu-img create -f qcow2 nuevo_disco.qcow2 10G
```

# para inciar la máquina virtual

```bash
qemu-system-x86_64 \
-name cpx21 \
-m 4G \
-smp 3 \
-hda debian-12-nocloud-amd64.qcow2 \
-device virtio-net-pci,netdev=net0 \
-netdev user,id=net0 \
-display sdl
```
## Explicación de los parámetros:

-name cpx21: Asigna el nombre "cpx21" a la máquina virtual.
-m 4G: Asigna 4GB de RAM.
-smp 3: Configura 3 CPUs virtuales.
-hda: Especifica la ruta a tu imagen de disco.
-net nic,model=virtio -net user: Configura la red virtual.
-display sdl: Usa SDL para mostrar la salida gráfica.

## configuración de red

```bash
-net nic,model=virtio -net user
```
Esta configuración crea una red NAT (Network Address Translation) por defecto. Con NAT:

La máquina virtual puede acceder a Internet a través de la conexión del host.
El host puede comunicarse con la máquina virtual, pero es necesario configurar el reenvío de puertos para acceder a servicios específicos.


Configuración de reenvío de puertos:

Para acceder a servicios específicos (como SSH) en tu máquina virtual, puedes usar el reenvío de puertos. Modifica la línea de red así:

```bash
-net nic,model=virtio,vlan=0,macaddr=52:54:00:72:60:01 -net user,hostfwd=tcp::2222-:22
```
Esto redirige el puerto 2222 de tu máquina Windows al puerto 22 (SSH) de la máquina virtual. Podrías conectarte usando SSH desde Windows con:

```bash
ssh -p 2222 usuario@localhost
```

tutorial youtube
https://www.youtube.com/watch?v=cE6X2IrTzgU&list=PLmsony4NVQpxYb6B51t-uWWuGkph5rmf1&ab_channel=Rick%27sNetTV
