Para agrandar un disco duro en una máquina virtual KVM/QEMU con Debian 12, sigue estos pasos:

1. **Apaga la máquina virtual** si está encendida.

2. **Aumenta el tamaño del disco virtual** (ejemplo para un disco qcow2):
```bash
qemu-img resize /ruta/al/disco.qcow2 +10G
```
Esto agrega 10 GB al disco. Cambia la ruta y el tamaño según lo que necesites.

3. **Inicia la máquina virtual**.

4. **Detecta el nuevo tamaño del disco** dentro de la VM:
```bash
sudo partprobe
```

5. **Expande la partición** (usando `cfdisk`, `fdisk` o `gparted`). Por ejemplo, con `cfdisk`:
```bash
sudo cfdisk /dev/vda
```
Elige la partición, expándela al nuevo tamaño y guarda los cambios.

6. **Redimensiona el sistema de archivos**. Por ejemplo, si usas ext4:
```bash
sudo resize2fs /dev/vda1
```
Ajusta `/dev/vda1` según tu partición.

¡Listo! El disco de tu VM ahora tendrá más espacio disponible. ¿Quieres instrucciones detalladas para algún paso específico?