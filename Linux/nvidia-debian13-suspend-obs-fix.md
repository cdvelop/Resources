# NVIDIA en Debian 13 (Trixie) — Fix Suspensión y Pérdida de Driver (OBS)

> **Contexto:** Después de suspender y reanudar el sistema (ej. al cerrar la tapa de la laptop), el driver NVIDIA pierde el estado y deja de funcionar.
> OBS Studio falla al intentar grabar indicando que faltan los drivers de NVIDIA (NVENC no disponible), obligando a reiniciar el equipo por completo.
>
> **Propósito:** Solucionar la pérdida del estado de la memoria de video (VRAM) tras suspender el equipo, permitiendo que OBS y otras aplicaciones sigan usando la GPU NVIDIA normalmente al reanudar.
>
> **Relacionado con:** [Diagnóstico Post-Upgrade Debian 13](./nvidia-debian13-post-upgrade-fix.md)

---

## ⚠️ Causa del Problema

Al suspender el sistema, por defecto el driver de NVIDIA no siempre preserva de manera segura el contenido de la memoria de video (VRAM). Al reanudar el equipo, las aplicaciones (como el servidor gráfico, OBS, etc.) no pueden recuperar el estado de la GPU. Esto provoca que el driver "se cuelgue" o quede en estado inconsistente, y OBS no reconozca el codificador NVENC.

Para solucionarlo, necesitamos indicarle al módulo del kernel de NVIDIA que **guarde la VRAM** antes de suspender y además, habilitar los servicios de `systemd` que NVIDIA provee para manejar este ciclo de energía correctamente.

---

## Paso 1 — Habilitar la preservación de VRAM en el módulo NVIDIA

Debemos agregar un parámetro al módulo de kernel de NVIDIA (`NVreg_PreserveVideoMemoryAllocations=1`) para que guarde la memoria de video durante la suspensión.

Copia y pega este comando en tu terminal para crear el archivo y añadir los parámetros directamente:

```bash
echo -e 'options nvidia NVreg_PreserveVideoMemoryAllocations=1\noptions nvidia NVreg_TemporaryFilePath=/var/tmp' | sudo tee /etc/modprobe.d/nvidia-power-management.conf
```

> **Nota:** `NVreg_TemporaryFilePath=/var/tmp` le indica a NVIDIA dónde debe guardar temporalmente el contenido de la VRAM. Asegúrate de tener espacio suficiente en tu partición principal (`/var/tmp`) equivalente a la VRAM de tu GPU (ej. 6GB). Si no agregas la ruta, por defecto intenta guardarlo en RAM.

---

## Paso 2 — Actualizar initramfs

Dado que los parámetros del módulo se leen en el arranque, es necesario actualizar el `initramfs` para que los cambios en `/etc/modprobe.d/` sean tomados en cuenta por el kernel.

```bash
sudo update-initramfs -u
```

---

## Paso 3 — Habilitar los servicios de Systemd de NVIDIA

NVIDIA proporciona scripts y servicios específicos para systemd que se encargan de coordinar el guardado y la restauración de la memoria durante los procesos de suspensión, hibernación y reanudación. Hay que activarlos para que funcionen junto con el parámetro que agregamos en el Paso 1.

Ejecuta:

```bash
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
```

*(Opcional)* Si quieres verificar que se han enlazado correctamente, la salida de los comandos mostrará algo como `Created symlink...`.

---

## Paso 4 — Reiniciar y Verificar

1. Reinicia el equipo para aplicar los cambios del kernel y cargar el módulo de NVIDIA con los nuevos parámetros:
   ```bash
   sudo reboot
   ```
2. Una vez reiniciado y logueado, **suspende la laptop** (puedes bajar la tapa o suspender desde el menú de tu entorno de escritorio).
3. **Despierta la laptop** (reanudar).
4. Abre **OBS Studio** e intenta iniciar una grabación. 
   > **Resultado esperado:** Ya no debería mostrar el error de "drivers faltantes" y la grabación por codificador de hardware (NVENC) debería iniciar y funcionar fluidamente.

---

## Posibles problemas o Troubleshooting adicional

* **Pantalla negra tras reanudar:** En algunos casos raros puede ocurrir un conflicto. Puedes verificar los logs ejecutando `journalctl -u nvidia-suspend.service` o `journalctl -u nvidia-resume.service` para ver si hubo errores al guardar en `/var/tmp`.
* **Sin espacio:** Si la suspensión falla de inmediato, verifica que tengas suficiente espacio libre en el disco (`df -h`).
* **Recargar sin reiniciar:** Si el módulo se colgó y no quieres reiniciar el equipo, revisa el [Anexo: Recargar Driver NVIDIA sin Reiniciar](./nvidia-debian13-reload-driver.md).

---

**Creado:** Mayo 2026
**Sistema:** Debian 13 (Trixie) 
**Hardware:** Laptop GPU NVIDIA GeForce RTX 3060 / Driver: 550.163.01
