# Recargar Driver NVIDIA sin Reiniciar (Debian 13)

> **Contexto:** En ocasiones, el driver de NVIDIA puede colgarse (por ejemplo, tras una suspensión donde se perdió el estado de la VRAM) y aplicaciones como OBS fallan al usar NVENC.
> **Propósito:** Intentar reiniciar el módulo de kernel de NVIDIA sin tener que hacer un reinicio completo del sistema (`reboot`).
>
> **⚠️ ADVERTENCIA CRÍTICA:** Si tu entorno de escritorio (GNOME, KDE) está usando la GPU NVIDIA para mostrar la pantalla, detener el driver **cerrará forzosamente tu sesión gráfica y perderás el trabajo no guardado**. En muchos casos, hacer esto toma el mismo esfuerzo que un reinicio normal.

---

## Método 1: Recarga suave (Si tienes laptop híbrida)

Si tienes una laptop Optimus donde la tarjeta integrada (Intel/AMD) maneja el escritorio y la NVIDIA solo se usa bajo demanda (ej. para OBS), a veces es posible recargar el driver cerrando solo esas apps.

### 1. Cerrar aplicaciones
Cierra completamente OBS Studio, juegos, navegadores web pesados, y cualquier app que esté consumiendo video.

### 2. Verificar qué usa la GPU
Abre una terminal y ejecuta:
```bash
sudo lsof /dev/nvidia*
```
Si este comando **no devuelve ninguna salida**, significa que la GPU está libre. Si te muestra una lista de programas, fíjate en el `PID` de esos procesos y ciérralos (o mátalos con `sudo kill -9 <PID>`).

### 3. Descargar (apagar) los módulos
Ejecuta estos comandos en orden:
```bash
sudo modprobe -r nvidia_drm
sudo modprobe -r nvidia_modeset
sudo modprobe -r nvidia_uvm
sudo modprobe -r nvidia
```
*(Nota: Si alguno de estos comandos te da un error tipo `FATAL: Module is in use`, significa que tu entorno gráfico tiene bloqueada la tarjeta y tendrás que usar el Método 2).*

### 4. Volver a cargar (encender) el driver
Si lograste descargarlos sin errores, vuelve a encenderlos:
```bash
sudo modprobe nvidia
sudo modprobe nvidia_modeset
sudo modprobe nvidia_uvm
sudo modprobe nvidia_drm
```
¡Listo! El driver se ha reiniciado. Abre OBS e intenta grabar.

---

## Método 2: Recarga dura (Reiniciar la sesión gráfica)

Si el `Método 1` te dio error de "module in use", significa que tu entorno gráfico (Xorg/Wayland) está atado a la GPU NVIDIA. 

**GUARDA TODO TU TRABAJO ANTES DE HACER ESTO:**

1. Cambia a una terminal de solo texto presionando: `Ctrl` + `Alt` + `F3` (o F4, F5).
2. Inicia sesión con tu usuario y contraseña.
3. Detén tu gestor de pantallas (si usas GNOME, usa `gdm3`; si usas KDE, usa `sddm` o `lightdm`):
   ```bash
   sudo systemctl stop gdm3
   ```
4. Ahora sí, descarga los módulos forzosamente:
   ```bash
   sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
   ```
5. Recarga los módulos de nuevo:
   ```bash
   sudo modprobe nvidia nvidia_modeset nvidia_uvm nvidia_drm
   ```
6. Vuelve a levantar tu entorno gráfico:
   ```bash
   sudo systemctl start gdm3
   ```
   *(Esto te devolverá a la pantalla de inicio de sesión de Debian).*

---

**Creado:** Mayo 2026
**Relacionado:** [Fix Suspensión y Pérdida de Driver (OBS)](./nvidia-debian13-suspend-obs-fix.md)
