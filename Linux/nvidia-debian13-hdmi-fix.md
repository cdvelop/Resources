# NVIDIA en Debian 13 (Trixie) — Fix Pérdida de Señal HDMI (Optimus + Wayland)

> **Contexto:** Tras reiniciar el sistema, aplicar una actualización o configurar los parámetros de suspensión, el monitor externo (TV) conectado por HDMI deja de recibir señal en laptops híbridas (Intel/AMD + NVIDIA).
>
> **Causa Principal:** En la gran mayoría de laptops *Optimus*, el puerto HDMI está soldado físicamente a la tarjeta de video NVIDIA. En **Debian 13**, el entorno de escritorio utiliza **Wayland** por defecto. Para que Wayland pueda enviar imagen a través del puerto HDMI de la tarjeta NVIDIA, requiere obligatoriamente que el parámetro **KMS (Kernel Mode Setting)** esté activado en el driver. Si falta, Wayland solo usa la gráfica integrada (ej. Intel) para la pantalla de la laptop, dejando el puerto HDMI "apagado".
>
> **Relación con cambios previos:** Si hace poco configuraste la preservación de VRAM (`NVreg_PreserveVideoMemoryAllocations=1`), es altamente probable que necesites explícitamente KMS para que la GPU inicialice correctamente las salidas de video en Wayland tras el arranque o la reanudación.

---

## Solución: Activar KMS (Kernel Mode Setting)

Para solucionar esto, debemos habilitar el parámetro `modeset=1` en el módulo `nvidia-drm`. 

### Alternativa Rápida (Script de una línea)

Puedes aplicar toda la corrección automáticamente ejecutando este único comando en tu terminal (te pedirá contraseña de `sudo`). Esto modificará la configuración de GRUB, creará el archivo necesario para el módulo de NVIDIA y reconstruirá tu gestor de arranque (es exactamente el paso unificado que ejecutamos para resolver el problema):

```bash
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' /etc/default/grub && echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia-drm-modeset.conf > /dev/null && sudo update-grub && sudo update-initramfs -u
```

---

### Método Manual (Paso a paso)

Si prefieres realizar y verificar las modificaciones de manera manual, sigue estos pasos:

### Paso 1 — Crear la configuración del módulo `nvidia-drm`

Abre una terminal y ejecuta el siguiente comando. Esto creará un archivo que le indicará al sistema que active KMS al cargar el driver de NVIDIA:

```bash
echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia-drm-modeset.conf
```

### Paso 2 — Agregar el parámetro a GRUB (Altamente Recomendado)

Para asegurar que el parámetro se cargue en la etapa más temprana del arranque y evitar problemas de inicialización (pantallas negras), añadiremos la instrucción directamente al gestor de arranque GRUB:

1. Edita el archivo de configuración de GRUB usando `nano` (o tu editor favorito):
   ```bash
   sudo nano /etc/default/grub
   ```

2. Busca la línea que comienza por `GRUB_CMDLINE_LINUX_DEFAULT=` y agrégale `nvidia-drm.modeset=1` dentro de las comillas. 
   *(Nota: si ya tienes otras palabras como `quiet` o `splash`, simplemente sepáralas con un espacio).*
   
   Ejemplo de cómo debería quedar:
   ```text
   GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"
   ```

3. Guarda los cambios (en nano: `Ctrl+O` -> `Enter` -> `Ctrl+X`).

4. Actualiza la configuración de GRUB ejecutando:
   ```bash
   sudo update-grub
   ```

### Paso 3 — Actualizar Initramfs

Dado que hemos agregado una nueva regla en `/etc/modprobe.d/`, necesitamos reconstruir el sistema de arranque inicial (`initramfs`) para que incorpore el cambio:

```bash
sudo update-initramfs -u
```

### Paso 4 — Reiniciar el equipo

Reinicia tu laptop para que se apliquen todas las configuraciones:

```bash
sudo reboot
```

---

## Verificación Post-Reinicio

Una vez que el sistema inicie sesión nuevamente, el monitor externo debería encenderse automáticamente. 

Si deseas comprobar que el parámetro se aplicó con éxito, puedes ejecutar en la terminal:
```bash
cat /sys/module/nvidia_drm/parameters/modeset
```
> **Resultado esperado:** Debería devolver `Y` (Yes), lo que significa que el KMS está activado correctamente.

---

**Creado:** Mayo 2026
**Sistema:** Debian 13 (Trixie) / Wayland
**Hardware:** Laptops Optimus (Intel + GPU NVIDIA)
