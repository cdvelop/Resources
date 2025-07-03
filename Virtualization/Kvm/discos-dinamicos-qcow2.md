# Cómo configurar discos dinámicos (crecimiento dinámico) en KVM/QEMU con imágenes qcow2

El formato qcow2 soporta crecimiento dinámico, lo que significa que el archivo de disco solo ocupa el espacio real utilizado por la máquina virtual, no el tamaño máximo asignado. Esto es ideal para ahorrar espacio en disco y gestionar mejor tus recursos.

## 1. Crear un disco qcow2 dinámico desde la terminal

Usa el siguiente comando para crear un disco qcow2 de crecimiento dinámico:

```bash
qemu-img create -f qcow2 /ruta/a/tu/disco.qcow2 20G
```
- `-f qcow2`: especifica el formato qcow2 (dinámico por defecto).
- `20G`: tamaño máximo que podrá alcanzar el disco, pero el archivo solo crecerá según el uso real.

**No uses la opción `-o preallocation=full`** a menos que quieras que el archivo ocupe todo el espacio desde el inicio (no recomendado para la mayoría de los casos).

## 2. Crear discos dinámicos desde la interfaz gráfica (virt-manager)

1. Al crear una nueva máquina virtual, en el paso de disco, selecciona el formato `qcow2`.
2. No marques ninguna opción de preasignación completa (como "asignar todo el espacio ahora").
3. El disco será dinámico por defecto.

## 3. Verificar si un disco qcow2 es dinámico

Puedes comprobar el formato y el espacio real usado con:

```bash
qemu-img info /ruta/a/tu/disco.qcow2
```
Busca:
- `file format: qcow2`
- `virtual size`: tamaño máximo
- `disk size`: espacio real ocupado

## 4. Convertir un disco existente a qcow2 dinámico

Si tienes un disco en formato raw o uno qcow2 que ocupa mucho espacio, puedes convertirlo:

```bash
qemu-img convert -O qcow2 /ruta/original.img /ruta/nueva.qcow2
```

## 5. Compactar un disco qcow2

Para liberar espacio no utilizado dentro de una imagen qcow2:

```bash
qemu-img convert -O qcow2 /ruta/vieja.qcow2 /ruta/compactada.qcow2
```
Luego reemplaza la imagen antigua por la compactada.

## 6. Notas adicionales
- El formato qcow2 es siempre de crecimiento dinámico salvo que se use preasignación completa.
- Si usas pools de almacenamiento personalizados, asegúrate de que el pool apunte a la carpeta deseada.
- Puedes automatizar la creación de discos dinámicos con scripts usando `qemu-img`.

---

¡Listo! Así te aseguras de que todos los discos de tus máquinas virtuales en KVM/QEMU sean dinámicos y eficientes en el uso de espacio.
