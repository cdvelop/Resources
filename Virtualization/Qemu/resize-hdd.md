Para agrandar un disco duro en una máquina virtual KVM/QEMU, sigue estos pasos:

## Desde el host (Linux)

1. **Apaga la máquina virtual** si está encendida.

2. **Aumenta el tamaño del disco virtual** (ejemplo para un disco qcow2):
```bash
qemu-img resize /ruta/al/disco.qcow2 +10G
```
Esto agrega 10 GB al disco. Cambia la ruta y el tamaño según lo que necesites.

3. **Inicia la máquina virtual**.

## Dentro de la VM - Linux (Debian/Ubuntu)

4. **Detecta el nuevo tamaño del disco**:
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

## Dentro de la VM - Windows Server (2012/2016/2019/2022)

4. Abre **Administración de discos** (`diskmgmt.msc`):
   - Presiona `Win + R`, escribe `diskmgmt.msc` y Enter.

5. El espacio nuevo aparecerá como **"No asignado"** junto al volumen existente. Si no aparece, haz clic derecho en el disco (ej. "Disco 0") y selecciona **"Volver a examinar los discos"**.

6. Haz clic derecho sobre el volumen que quieres extender (ej. `C:`) y selecciona **"Extender volumen..."**.

7. Sigue el asistente: acepta el tamaño máximo disponible y finaliza.

> **Nota**: Si el espacio no asignado no está contiguo al volumen (hay una partición de recuperación en medio), deberás mover o eliminar esa partición primero. En ese caso puedes usar la herramienta `diskpart` desde CMD como administrador:
> ```cmd
> diskpart
> list disk
> select disk 0
> list partition
> select partition 2
> extend
> ```
> Ajusta el número de partición según tu caso.