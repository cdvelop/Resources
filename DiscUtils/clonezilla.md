# Clonezilla — Clonar disco completo (UEFI)

Notas propias. Caso de uso: clonar un disco USB con un sistema operativo completo
hacia un disco nuevo, para usarlo en otra máquina.

ISO usada: `clonezilla-live-3.3.3-15-amd64.iso` (en `/media/user_name/support/ISOS/`,
arrancable desde Ventoy). Alternativa gráfica: `rescuezilla-2.6.2-64bit.noble.iso`.

---

## 0. Antes de empezar

- Conecta **origen y destino a la misma máquina**. Clonezilla necesita ver los dos
  discos a la vez para el modo `device-device`.
- El disco destino se **borra completo**.
- El destino debe ser **igual o más grande** que el origen.
- Anota antes modelo y tamaño de cada disco. En Clonezilla los eliges por
  `/dev/sdX` + modelo, y las letras cambian entre arranques.

Para identificarlos desde Linux antes de arrancar:

```bash
lsblk -o NAME,SIZE,MODEL,SERIAL,TRAN,PTTYPE,MOUNTPOINT
```

`PTTYPE=gpt` indica disco UEFI moderno; `dos` indica MBR/BIOS.

---

## 1. Arrancar en modo UEFI

En la BIOS/UEFI de la máquina:

- **Desactiva CSM / Legacy Boot.**
- Si el equipo no arranca Ventoy, desactiva **Secure Boot** (o usa la opción de
  Ventoy con soporte Secure Boot).

Esto importa: si arrancas Clonezilla en modo Legacy sobre un disco GPT/UEFI, el
clon puede salir bien pero el disco resultante no arrancar.

En el menú de Clonezilla elige:

```
Clonezilla live (Default settings, VGA 1024x768)
```

---

## 2. Menús iniciales

| Pantalla | Elección |
|---|---|
| Language | `es_ES.UTF-8 Spanish` |
| Configuring console-data | `Keep the default keyboard layout` |
| Start Clonezilla | `Start_Clonezilla` |
| Modo | **`device-device`** (disco a disco directo) |
| Nivel | `Beginner` |
| Tipo de clonado | **`disk_to_local_disk`** |

> Si no puedes tener los dos discos en la misma máquina, usa `device-image` →
> `savedisk` hacia un disco externo, y luego `restoredisk` en la otra máquina.

---

## 3. Elegir discos

1. **Disco ORIGEN** (`local disk as source`) — el USB con el sistema operativo.
2. **Disco DESTINO** (`local disk as target`) — el disco nuevo, se borrará.

Verifica el tamaño y el modelo que muestra cada línea. Este es el paso donde un
error destruye datos.

---

## 4. Pantalla de comprobación del sistema de archivos ← *la de la duda*

Aparecen tres opciones:

| Opción | Qué hace |
|---|---|
| `-sfsck` | **Omitir** la comprobación del sistema de archivos de origen |
| `-fsck-src-part` | Comprobar y reparar el origen de forma **interactiva** |
| `-fsck-src-part-y` | Comprobar y reparar el origen **automáticamente** (responde "sí" a todo) |

### Elegir: `-sfsck`

Es la opción por defecto y la correcta en un clonado normal. Razones:

1. **No modifica el origen.** `fsck` escribe sobre el disco de origen. Al clonar, lo
   que quieres es que el origen se comporte como solo-lectura. Si algo sale mal
   durante la reparación, dañas el disco bueno *antes* de tener la copia.
2. **Cobertura limitada.** Solo soporta ext2/3/4, reiserfs, xfs, jfs y vfat. Si el
   origen es **NTFS (Windows), btrfs o APFS, no hace nada útil** — elegirlo solo
   añade tiempo.
3. **Tarda mucho** en discos grandes, sin beneficio si el sistema de archivos ya
   está sano.

`-fsck-src-part-y` es el más arriesgado: acepta automáticamente todas las
correcciones, incluido mover archivos a `lost+found`.

**Regla práctica:** si sospechas que el sistema de archivos está dañado, no lo
repares aquí. Clona primero con `-sfsck` y repara **después, sobre la copia** —
así conservas el original intacto por si la reparación empeora las cosas.

- Linux: `sudo fsck -f /dev/sdXN` (desmontado)
- Windows: `chkdsk C: /f` desde el propio Windows (`ntfsfix` de Linux no
  sustituye a `chkdsk`)

---

## 5. Guardar los archivos de log (`-plu`)

> *"Log files to a Clonezilla live USB drive if it exists"*

**Sí, actívala.** No cuesta nada y guarda el registro del trabajo (incluida la
salida de `partclone`, que es donde aparecen los sectores ilegibles y los avisos)
en el propio medio live, para poder leerlo después de reiniciar. Sin esto, los
logs viven en RAM (`/var/log/clonezilla.log`) y **se pierden al apagar** — justo
cuando más los necesitas, que es cuando el clon falló y quieres saber por qué.

### Advertencia con Ventoy

Arrancando desde Ventoy, la ISO se monta como un **CD virtual de solo lectura**, no
como la partición USB escribible. Clonezilla busca su propio medio live para
escribir ahí, encuentra el ISO de solo lectura y **el guardado falla en silencio**.

Elegirla igual no rompe nada. Pero si el clonado da errores y necesitas el log,
haz esto **antes de reiniciar**: al terminar elige `enter command line prompt` y
copia el log a mano a una partición escribible:

```bash
sudo blkid                          # localizar la partición de datos del USB
sudo mkdir -p /mnt/usb
sudo mount /dev/sdXN /mnt/usb
sudo cp /var/log/clonezilla.log /mnt/usb/
sudo umount /mnt/usb
```

---

## 6. Últimas preguntas

| Pantalla | Elección |
|---|---|
| Acción al terminar | `-p choose` (decidir al final) o `-p poweroff` |
| Tabla de particiones destino *(si aparece)* | usar la tabla del disco origen — mantiene ESP y GPT |
| Confirmación | `Enter`, luego `y` + `Enter`, y otra vez `y` + `Enter` |

Clonezilla pide confirmación **dos veces** porque el destino se destruye. A partir
del segundo `y` empieza a escribir.

---

## 7. Después del clonado

### Ampliar la partición si el destino es más grande

En modo `Beginner` las particiones se copian con su tamaño original y el espacio
sobrante queda sin asignar. Amplía la última partición con GParted
(`gparted-live`) o:

```bash
sudo growpart /dev/sdX N
sudo resize2fs /dev/sdXN      # ext4
# NTFS: usar GParted, o Administración de discos en Windows
```

> En modo `Expert` existe la opción `-k1` para crear la tabla de particiones
> proporcionalmente y evitar este paso.

### Arrancar en la otra máquina

- Deja la BIOS destino en **UEFI, sin CSM**.
- **Si el SO es Linux:** normalmente arranca sin tocar nada. Si falla, arranca un
  live, haz `chroot` y regenera:
  ```bash
  update-initramfs -u -k all
  grub-install --target=x86_64-efi --efi-directory=/boot/efi
  update-grub
  ```
- **Si el SO es Windows:** el fallo típico es pantalla azul `INACCESSIBLE_BOOT_DEVICE`
  por un controlador de disco distinto. Cambia el modo SATA de la BIOS destino a
  **AHCI** (no RAID/VMD). Si no arranca el gestor de arranque, desde WinPE:
  ```
  bcdboot C:\Windows /s S: /f UEFI
  ```
  (`S:` = partición EFI, montada con `diskpart` → `assign letter=S`).

### Discos con el mismo UUID

Tras clonar, origen y destino tienen **UUID y GUID idénticos**. Si conectas los dos
a la vez en el mismo equipo, el arranque puede montar el disco equivocado.
Mantén solo uno conectado hasta haber cambiado los identificadores del clon
(GParted → *New UUID*, o `tune2fs -U random /dev/sdXN`).

---

## Apéndice — Modo imagen (discos en máquinas distintas)

```
device-image → local_dev → (elegir disco donde guardar la imagen)
             → Beginner → savedisk
```

Luego, en la máquina destino, con el mismo disco externo conectado:

```
device-image → local_dev → Beginner → restoredisk
```

La imagen ocupa solo el espacio usado (comprimida), no el tamaño del disco.
