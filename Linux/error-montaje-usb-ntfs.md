# Error de Montaje de Disco USB (NTFS) en Linux (Debian)

## El Problema
Al conectar un disco duro externo USB formateado en NTFS, el administrador de archivos muestra el siguiente error al intentar acceder a él:

```text
Unable to access "backup"
Error mounting /dev/sda1 at /media/cesar/backup: wrong fs type, bad option, bad superblock on /dev/sda1, missing codepage or helper program, or other error
```

## Causa Principal
Este error **no significa que el disco esté dañado físicamente**. Ocurre porque el sistema de archivos NTFS quedó en un estado "sucio" (inconsistente) debido a un cierre o desconexión incorrecta en un sistema Windows. Como medida de protección para no corromper tus datos, Linux (Debian) bloquea el montaje de la unidad.

Las razones más comunes son:
1. El disco fue extraído físicamente de un equipo con Windows sin utilizar la opción **"Quitar hardware con seguridad"**.
2. El equipo con Windows se apagó teniendo activada la función de **"Inicio rápido" (Fast Startup)** o entró en estado de hibernación, lo que no cierra correctamente los sistemas de archivos conectados.

---

## Soluciones

### Solución 1: Desde la terminal de Linux (Rápida)
Puedes intentar reparar la inconsistencia directamente desde Debian usando las herramientas de NTFS.

1. Abre una terminal.
2. Ejecuta el comando de reparación (te pedirá tu contraseña de usuario):
   ```bash
   sudo ntfsfix /dev/sda1
   ```
   *(Nota: Sustituye `/dev/sda1` por la ruta real de tu partición en caso de que cambie. Puedes verificarla con `lsblk -f`).*
3. Una vez finalizado el proceso, intenta montar la unidad nuevamente desde tu administrador de archivos.

### Solución 2: Usando una Máquina Virtual de Windows en KVM (La más segura)
Dado que NTFS es un sistema de archivos propietario de Microsoft, la herramienta nativa de Windows es la más eficaz. Puedes hacer un "Passthrough" (redirección) de tu USB físico a una máquina virtual con Windows 10 usando `virt-manager`.

**Paso a paso:**
1. Abre `virt-manager` y enciende tu máquina virtual de Windows 10.
2. Conecta el USB a la máquina virtual:
   - **Vía SPICE (Recomendado y rápido):** En la ventana de visualización de tu VM, ve al menú superior: `Máquina Virtual` > `Redirigir dispositivo USB`. Selecciona tu disco en la lista.
   - **Vía Hardware:** Haz clic en el ícono del bombillo azul (Detalles), ve a `Añadir Hardware` > `Dispositivo USB Host`, selecciona tu disco y finaliza.
3. Dentro del Windows de la máquina virtual, ve a "Este equipo". Si Windows lanza una notificación ofreciendo reparar la unidad, acéptala.
4. Si no hay notificación automática, abre el Símbolo del Sistema (`cmd`) como administrador y ejecuta la herramienta de comprobación:
   ```cmd
   chkdsk /f E:
   ```
   *(Cambia `E:` por la letra que el Windows virtual le haya asignado a tu USB).*
5. **Paso crítico:** Cuando termine la comprobación, ubica el ícono del USB en la barra de tareas de Windows (abajo a la derecha) y haz clic en **"Quitar hardware con seguridad"**.
6. Desconecta el USB de la máquina virtual (desmarcando la redirección o quitando el hardware añadido).
7. Finalmente, tu Debian debería poder montar el disco sin ningún inconveniente.
