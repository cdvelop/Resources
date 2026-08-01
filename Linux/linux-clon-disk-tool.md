# Clonación de disco Windows 10 (VM KVM/QEMU) a máquina física

## 0. Contexto detectado en este equipo

- Host: Debian 13, gestor de virtualización **libvirt + QEMU/KVM** (no VirtualBox/VMware).
- VM origen: `win10` (actualmente **encendida**).
- Disco activo de la VM: `~/Dev/VM/QEMU/images/win10.1775277046` (adjunto como `sda`).
- Hay un disco base más antiguo `win10.qcow2` (40 GiB virtuales) con snapshots **internos** (`reziseDisk40gb`, `drivers-ok`, `windows-activate`, `windows-update`).
- `virsh snapshot-list win10` reporta además `edgeConfig`, `keyboardOK`, `ready-manual-test`, `reziseDisk`, `ssh-install`: esto indica que en algún punto se mezclaron **snapshots internos** (dentro del propio `.qcow2`) con **snapshots externos con memoria** (archivos `win10-mem.*` junto a nuevos overlays `win10.<id>`). Es una topología mixta, típica de pruebas manuales con `virsh snapshot-create` sin el flag `--disk-only`.
- Drivers: existe un ISO `virtio-win-0.1.285.iso` adjunto, y hay un snapshot llamado `drivers-ok`, lo que confirma que la VM usa **virtio** para disco/red. Esto es relevante porque el hardware real casi seguro **no** tendrá controladora virtio.
- `libguestfs-tools` (que provee `virt-sysprep`, `virt-sparsify`, `virt-v2v`) aparece como **`rc`** (instalado antes, purgado ahora). No lo vamos a necesitar para el paso de sysprep de Windows (ver justificación más abajo), pero si quieres inspeccionar el disco offline sin arrancar la VM, tendrías que reinstalarlo: `sudo apt install libguestfs-tools`.

## 1. Preparación (obligatorio antes de tocar el disco)

1. Apaga la VM de forma limpia (no la fuerces si vas a usar snapshots internos, para no dejar el qcow2 inconsistente):
   ```bash
   virsh -c qemu:///system shutdown win10
   ```
2. Confirma que quedó apagada:
   ```bash
   virsh -c qemu:///system list --all
   ```
3. Identifica exactamente qué snapshot quieres usar y si es interno o externo:
   ```bash
   virsh -c qemu:///system snapshot-list win10 --tree
   virsh -c qemu:///system snapshot-info win10 --snapshotname NOMBRE_SNAPSHOT
   ```
   - Si el snapshot aparece en `qemu-img snapshot -l win10.qcow2`, es **interno**.
   - Si en vez de eso hay un archivo `win10.<id>` + `win10-mem.<nombre>` en `images/`, es **externo con memoria** (más pesado, pero también más fácil de aislar porque ya es un archivo qcow2 independiente).
4. **Nunca trabajes sobre el disco original.** Todo lo siguiente parte de una copia.

## 2. Extraer el estado del snapshot elegido a una imagen independiente

### Caso A — snapshot interno (dentro de `win10.qcow2`)

`qemu-img` permite exportar el estado de un snapshot interno sin necesidad de revertir el disco en vivo:

```bash
qemu-img convert -O qcow2 -l snapshot.name=NOMBRE_SNAPSHOT \
  ~/Dev/VM/QEMU/images/win10.qcow2 \
  ~/Dev/VM/QEMU/images/win10-sysprep-source.qcow2
```

Esto crea un archivo nuevo, autocontenido, congelado exactamente en el punto de ese snapshot. El original queda intacto.

### Caso B — snapshot externo (archivo `win10.<id>` + memoria)

El archivo `win10.<id>` ya es un qcow2 con backing file hacia `win10.qcow2`. Aplánalo (resuelve la cadena de backing files) para tener un único archivo portable:

```bash
qemu-img convert -O qcow2 \
  ~/Dev/VM/QEMU/images/win10.<id> \
  ~/Dev/VM/QEMU/images/win10-sysprep-source.qcow2
```

(El archivo `win10-mem.*` es el estado de RAM del snapshot en vivo; no lo necesitas para clonar, solo para restaurar la VM exactamente como estaba corriendo.)

## 3. Levantar una VM temporal desde esa imagen para ejecutar Sysprep

Sysprep **debe ejecutarse dentro de Windows en caliente**, no se puede aplicar "desde afuera" con herramientas Linux. Usa la copia aislada:

```bash
virt-install \
  --connect qemu:///system \
  --name win10-sysprep-temp \
  --memory 4096 --vcpus 2 \
  --disk path=~/Dev/VM/QEMU/images/win10-sysprep-source.qcow2,bus=virtio \
  --import --os-variant win10 \
  --graphics spice
```

Conéctate con `virt-viewer` o `virt-manager` a `win10-sysprep-temp` y entra a Windows normalmente.

## 4. Ejecutar Sysprep dentro de Windows

Dentro de la VM temporal, abre PowerShell/CMD como administrador:

```
%WINDIR%\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown
```

- `/generalize`: quita el SID único, el estado de activación asociado al hardware y drivers "vinculados" a esta instancia — esto es lo que hace que la imagen sea **clonable** legalmente y sin conflictos de SID al desplegarla en otra máquina.
- `/oobe`: al primer arranque en el equipo real, Windows pedirá el asistente de configuración inicial (región, usuario, etc.), como si fuera de fábrica.
- `/shutdown`: apaga la VM al terminar, dejando el disco en el estado correcto para clonar (no reinicies manualmente después, eso invalida el generalize).

Si necesitas repetirlo sin límite, ten en cuenta que Windows solo permite `sysprep /generalize` un número limitado de veces (contador `GeneralizationState`/`CleanupState` en el registro, normalmente 3-8 usos antes de bloquear el rearm). Como estás partiendo de una copia de snapshot cada vez, no consumes el contador de tu VM de trabajo real.

Cuando la VM temporal termine de apagarse sola, **no la vuelvas a encender**: `win10-sysprep-source.qcow2` ya contiene el sistema generalizado listo para clonar.

## 5. Clonar la imagen generalizada al disco físico real

### Herramienta recomendada: Clonezilla (Live) — y por qué

Para el paso de "poner esto en un disco físico real" hay tres familias de opciones. Justificación de por qué Clonezilla es la más adecuada en **tu** caso concreto:

| Opción | Problema en tu escenario |
|---|---|
| `dd` / `qemu-img convert -O raw` directo al disco físico | Copia bit a bit el tamaño **exacto** del virtual disk (40 GiB). Si el disco real es de otro tamaño (mayor o menor), no ajusta particiones ni GPT automáticamente, y no es consciente del sistema de archivos (copia también espacio vacío, lento). |
| Macrium Reflect / herramientas solo-Windows | Requiere arrancar Windows para tomar la imagen, agregando un paso extra de arranque intermedio; útil si prefieres GUI de Windows, pero no aporta ventaja sobre Clonezilla en tu flujo, que ya vive en Linux/QEMU. |
| **Clonezilla Live** | Trabaja a nivel de partición, es consciente de NTFS (usa `ntfsclone`, copia solo bloques usados → mucho más rápido y admite redimensionar la partición al tamaño real del disco destino), es independiente del SO anfitrión (Live ISO), y se integra naturalmente con tu stack QEMU/KVM: puedes montar `win10-sysprep-source.qcow2` como disco de una VM temporal con Clonezilla y generar la imagen, o escribir directo a un disco físico pasado por USB/passthrough. |

Con tu VM ya apagada tras el sysprep, el flujo con Clonezilla es:

**5.1 Generar la imagen de Clonezilla desde el qcow2 (sin tocar hardware aún)**

```bash
virt-install \
  --connect qemu:///system \
  --name clonezilla-helper \
  --memory 2048 --vcpus 2 \
  --disk path=~/Dev/VM/QEMU/images/win10-sysprep-source.qcow2,bus=virtio \
  --disk /ruta/a/clonezilla-live.iso,device=cdrom \
  --boot cdrom \
  --graphics spice
```

Arranca Clonezilla, elige `device-image`, `save disk`, guarda hacia una carpeta compartida por red (Samba/NFS) o hacia un disco USB pasado por `--filesystem`/passthrough a la VM.

**5.2 Restaurar en el disco físico real**

Con la imagen de Clonezilla generada, arranca la máquina física destino desde un USB de Clonezilla Live y usa `restoredisk` apuntando al mismo image store (USB/red). Clonezilla se encarga de:
- Recrear la tabla de particiones (MBR/GPT) ajustada al disco real.
- Restaurar el arranque (bootloader) correctamente.
- Redimensionar la partición Windows si el disco destino es más grande.

## 6. Consideraciones post-clonado en hardware real (importante para Windows)

1. **Controlador de almacenamiento**: la VM usa virtio (ver snapshot `drivers-ok`). El hardware real probablemente use AHCI/NVMe estándar, que Windows 10 trae "inbox" (no necesitas inyectar drivers en ese caso). Si el disco real es un RAID o un chipset propietario no soportado nativamente, el equipo dará BSOD `INACCESSIBLE_BOOT_DEVICE` al primer arranque — en ese caso inyecta el driver correcto con DISM antes de sysprep (`dism /image:C:\ /add-driver /driver:X:\driver.inf`) o usa la función *ReDeploy* de Macrium Reflect solo si Clonezilla falla en arrancar.
2. **Activación**: al hacer `/generalize`, Windows entra en modo OOBE de fábrica; si la licencia está atada a hardware (OEM/digital license vinculada a la placa madre original de la VM), tendrás que reactivar con una key válida para el equipo físico.
3. **Drivers de red/chipset/GPU** del hardware real: no vienen preinstalados desde la VM (ahí solo estaba virtio). Instálalos tras el primer arranque OOBE.
4. No vuelvas a arrancar `win10-sysprep-source.qcow2` una vez usado — está generalizado; si necesitas otra copia física, repite el paso 2 desde el snapshot original (que sigue intacto).

## 7. Checklist rápido

- [ ] VM `win10` apagada limpiamente.
- [ ] Snapshot identificado (interno o externo) con `virsh snapshot-list --tree`.
- [ ] Copia aislada extraída con `qemu-img convert` (nunca sobre el original).
- [ ] Sysprep ejecutado (`/oobe /generalize /shutdown`) dentro de una VM temporal.
- [ ] Imagen generalizada capturada con Clonezilla.
- [ ] Imagen restaurada en el disco físico real vía Clonezilla Live USB.
- [ ] Verificado arranque en hardware real; drivers de almacenamiento/red/GPU instalados si hace falta.
