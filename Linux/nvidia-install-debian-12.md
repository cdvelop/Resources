# ⚙️ Guía Completa: Instalar Driver NVIDIA en Debian 12

> ℹ️ Esta guía fue probada después de instalar una versión mínima de Debian 12 con gnome-shell siguiendo el tutorial del canal **Juan J.J. - Linuxeroerrante**.

---

## ⚙️ Requisitos Previos

| ✔️ Verificar | Descripción |
|--------------|-------------|
| ⚙️ **Sistema** | Debian 12 (Bookworm) con GNOME instalado |
| ⚙️ **Acceso** | Usuario con privilegios sudo |
| ⚡ **Internet** | Conexión estable a internet |
| ⚙️ **Espacio** | Al menos 1GB de espacio libre |

## ⚡ Tutoriales Recomendados
---
[![Instalando Driver Propietario NVIDIA en Debian 12](https://img.youtube.com/vi/QHjTZk0lBUU/0.jpg)](https://www.youtube.com/watch?v=cnXNFdTCW1M)
---
[![debian 12](https://img.youtube.com/vi/cnXNFdTCW1M/0.jpg)](https://www.youtube.com/watch?v=cnXNFdTCW1M)
---

## ⚡ PASOS:

### ⚙️ 1. Habilita repositorios **contrib** y **non‑free**

#### ℹ️ Paso a paso:

1. **Abre una terminal** (`Ctrl + Alt + T`)
2. **Edita el archivo de fuentes** con tu editor favorito:
   ```bash
   sudo nano /etc/apt/sources.list
   ```
3. **Modifica las líneas** para que se vean así:
   ```text
   deb http://deb.debian.org/debian bookworm main contrib non-free
   deb http://deb.debian.org/debian bookworm-updates main contrib non-free
   deb http://deb.debian.org/debian-security bookworm-security main contrib non-free
   ```
4. **Guarda y cierra** el archivo (`Ctrl + X`, luego `Y`, luego `Enter`)
5. **Actualiza la lista de paquetes:**
   ```bash
   sudo apt update
   ```

| ✔️ Resultado Esperado |
|----------------------|
| Sin errores en la actualización de repositorios |

ℹ️ **Referencias:** [tecmint.com][1], [reddit.com][2]

---

### ⚙️ 2. Instala herramientas necesarias

> ℹ️ **¿Por qué?** Estas herramientas son necesarias para compilar y detectar el driver correcto.

#### ⚡ Comando único:
```bash
sudo apt install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config nvidia-detect
```

#### ⚙️ ¿Qué instala cada paquete?

| Paquete | Propósito |
|---------|-----------|
| `linux-headers-$(uname -r)` | Headers del kernel actual para compilación |
| `build-essential` | Herramientas de compilación (gcc, make, etc.) |
| `libglvnd-dev` | Bibliotecas OpenGL necesarias |
| `pkg-config` | Herramienta de configuración de paquetes |
| `nvidia-detect` | Detecta automáticamente el driver recomendado |

#### ⚡ Verifica el driver recomendado:
```bash
nvidia-detect
```

| ✔️ Resultado Esperado |
|----------------------|
| Mensaje sugiriendo instalar `nvidia-driver` u otra versión específica |

ℹ️ **Referencias:** [phoenixnap.com][3]

---

### 3. Blacklistea el driver **nouveau**

> ⚠️ **¡Importante!** El driver libre `nouveau` puede causar conflictos con el driver propietario de NVIDIA.

#### ⚙️ Pasos:

1. **Crea el archivo de blacklist:**
   ```bash
   echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
   ```
2. **Actualiza initramfs:**
   ```bash
   sudo update-initramfs -u
   ```
3. **Cambia al modo terminal (sin interfaz gráfica):**
   ```bash
   sudo systemctl set-default multi-user.target
   ```
4. **Reinicia el sistema:**
   ```bash
   sudo reboot
   ```

> ⚠️ **Después del reinicio:** Tu sistema iniciará en modo texto (sin escritorio). Esto es normal y necesario.

| ⚠️ Nota Importante |
|-------------------|
| Después del reinicio verás solo una terminal negra. ¡No te preocupes! Es lo esperado. |

ℹ️ **Referencias:** [phoenixnap.com][3]

---

### ⚙️ 4. Instala el driver NVIDIA

> ℹ️ **Contexto:** Ahora estás en modo terminal. Inicia sesión con tu usuario y contraseña.

#### ⚙️ Instalación:

1. **Instala el driver:**
   ```bash
   sudo apt install nvidia-driver
   ```
   > ℹ️ **Nota:** Si `nvidia-detect` recomendó una versión específica, úsala en su lugar.
2. **Restaura el modo gráfico:**
   ```bash
   sudo systemctl set-default graphical.target
   ```
3. **Reinicia el sistema:**
   ```bash
   sudo reboot
   ```

#### ⚙️ Tiempo de instalación

| Componente | Tiempo Estimado |
|------------|-----------------|
| Descarga de paquetes | 2-5 min |
| Instalación | 3-5 min |
| Configuración | 1-2 min |

ℹ️ **Referencias:** [wiki.debian.org][4]

---

### ✔️ 5. Verifica instalación

> ℹ️ **¡Ya casi terminamos!** Ahora deberías estar de vuelta en GNOME.

#### ⚡ Comando de verificación:
```bash
nvidia-smi
```

#### ⚡ Resultado que obtuve, deberías ver algo similar:
```text
Tue Jul  1 00:23:51 2025       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.247.01             Driver Version: 535.247.01   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 3060 ...    On  | 00000000:01:00.0  On |                  N/A |
| N/A   36C    P8              11W /  80W |     57MiB /  6144MiB |     35%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A      1637      G   /usr/lib/xorg/Xorg                           53MiB |
+---------------------------------------------------------------------------------------+
```

#### ⚙️ ¿Qué significa cada parte?

| Sección | Descripción | Ejemplo |
|---------|-------------|---------|
|  **Fecha/Hora** | Momento de la consulta | `Tue Jul 1 00:23:51 2025` |
|  **Driver Version** | Versión del driver instalado | `535.247.01` |
|  **CUDA Version** | Versión de CUDA soportada | `12.2` |
|  **GPU Name** | Modelo de tu tarjeta gráfica | `NVIDIA GeForce RTX 3060` |
|  **Temp** | Temperatura actual | `36C` |
| ⚡ **Power** | Consumo energético actual/máximo | `11W / 80W` |
|  **Memory** | Memoria GPU usada/total | `57MiB / 6144MiB` |
|  **GPU-Util** | Porcentaje de uso de la GPU | `35%` |

| ✔️ Señales de Éxito |
|--------------------|
| ⚙️ Se muestra información detallada de tu GPU |
| ✔️ La versión del driver es visible |
| ✔️ No aparecen mensajes de error |
| ✔️ Se muestran procesos usando la GPU |
| ✔️ La temperatura y consumo son normales |

ℹ️ **Referencias:** [reddit.com][2]

---

### ⚡ 6. Alternativa: Instalador `.run`

> ⚠️ **Método avanzado:** Para usuarios que prefieren el instalador oficial de NVIDIA.

#### ⚙️ Requisitos previos:
- ✔️ Ya completaste los pasos 1-3 (repositorios, herramientas, blacklist nouveau)
- ✔️ Estás en modo terminal (sin interfaz gráfica)

#### ⚙️ Proceso de instalación:

1. **Descarga el instalador** desde [nvidia.com](https://www.nvidia.com/drivers)
2. **Ejecuta el instalador:**
   ```bash
   bash NVIDIA-Linux-*.run
   ```
3. **Durante la instalación, acepta:**
   | Opción | Recomendación |
   |--------|---------------|
   | ⚙️ Ignorar mismatches de GCC | ✔️ **Sí** |
   | ⚙️ Instalar librerías 32-bit | ✔️ **Sí** |
   | ⚙️ Instalar libglvnd | ✔️ **Sí** |
   | ⚙️ Ejecutar nvidia-xconfig | ✔️ **Sí** |
4. **Reconstruye initramfs:**
   ```bash
   sudo update-initramfs -u
   ```
5. **Rehabilita la interfaz gráfica:**
   ```bash
   sudo systemctl set-default graphical.target
   sudo reboot
   ```

ℹ️ **Referencias:** [phoenixnap.com][3]

---

### ⚙️ 7. Secure Boot y módulos firmados

> ⚠️ **¿Tienes Secure Boot activado?** Aquí están tus opciones.

#### ⚙️ Tabla de escenarios:

| Escenario | Driver desde Repos | Driver `.run` |
|-----------|-------------------|---------------|
| ⚠️ **Secure Boot ON** | ⚠️ Requiere firma del módulo | ⚠️ Puede fallar |
| ✔️ **Secure Boot OFF** | ✔️ Funciona directamente | ✔️ Funciona directamente |

#### ⚙️ Opciones para Secure Boot:

1. **Opción 1 - Deshabilitar Secure Boot (Más fácil):**
   - Reinicia y entra al BIOS/UEFI (`F2`, `F12`, `Del` durante el arranque)
   - Busca `Secure Boot` en configuración de seguridad
   - Cambia a `Disabled`
   - Guarda y reinicia
2. **Opción 2 - Firmar módulos (Avanzado):**
   - Requiere generar claves de firma
   - Proceso complejo, recomendado solo para usuarios experimentados

| ⚠️ Recomendación para Novatos |
|------------------------------|
| ✔️ **Deshabilita Secure Boot** durante la instalación del driver. Puedes reactivarlo después si lo necesitas. |

ℹ️ **Referencias:** [linuxconfig.org][5], [forums.developer.nvidia.com][6]

---

## ⚙️ Resumen de Comandos Rápidos

> ⚡ **Para usuarios experimentados:** Secuencia completa de comandos.

```bash
# 1. Actualizar repositorios (después de editar sources.list)
sudo apt update
# 2. Instalar herramientas necesarias
sudo apt install linux-headers-$(uname -r) build-essential libglvnd-dev pkg-config nvidia-detect
# 3. Verificar driver recomendado
nvidia-detect
# 4. Blacklist nouveau
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u
# 5. Cambiar a modo texto y reiniciar
sudo systemctl set-default multi-user.target
sudo reboot
# 6. Instalar driver (después del reinicio, en modo terminal)
sudo apt install nvidia-driver
# 7. Volver al modo gráfico y reiniciar
sudo systemctl set-default graphical.target
sudo reboot
# 8. Verificar instalación (en GNOME)
nvidia-smi
```

---

## ⚡ Solución de Problemas Comunes

| Problema | Síntoma | Solución |
|----------|---------|----------|
| ⚙️ Pantalla negra | No aparece escritorio después de instalar | Reinicia en modo recovery y revierte cambios |
| ⚠️ "nouveau" activo | `nvidia-smi` dice "No devices found" | Verifica que nouveau esté blacklisteado |
| ⚠️ Boot loop | Sistema reinicia continuamente | Inicia en modo recovery y desinstala driver |
| ⚠️ Secure Boot error | Error de módulo no firmado | Deshabilita Secure Boot en BIOS |

### ⚙️ Comandos de emergencia:

```bash
# Desinstalar driver NVIDIA
sudo apt remove --purge nvidia-*
# Reactivar nouveau
sudo rm /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u
# Modo recovery
# Selecciona "Advanced options" en GRUB y luego "recovery mode"
```

---

## ℹ️ Referencias y Fuentes

| Fuente | Descripción | Enlace |
|--------|-------------|---------|
| ⚡ Tecmint | Instalación drivers NVIDIA Debian 12 | [tecmint.com][1] |
| ⚡ Reddit | Guía paso a paso usuarios novatos | [reddit.com][2] |
| ⚡ Phoenix NAP | Instalación drivers NVIDIA | [phoenixnap.com][3] |
| ℹ️ Debian Wiki | Documentación oficial drivers | [wiki.debian.org][4] |
| ℹ️ LinuxConfig | Debian 12 Bookworm | [linuxconfig.org][5] |
| ℹ️ NVIDIA Forums | Soporte técnico oficial | [forums.developer.nvidia.com][6] |

## ℹ️ Créditos y Agradecimientos

- ℹ️ **Juan J.J. - Linuxeroerrante**, **Mi Rincón Linux** por los excelentes tutoriales en video
- ℹ️ **Comunidad Debian** por la documentación y soporte
- ⚙️ **NVIDIA** por proporcionar drivers para Linux

> ℹ️ **¿Encontraste algún error o tienes sugerencias?**
> 
> Esta guía está en constante mejora. Si tienes feedback o encuentras problemas, por favor comparte tu experiencia para ayudar a otros usuarios.

---

**ℹ️ Última actualización:** Julio 2025  
**⚡ Versión:** 2.0 - Mejorada y estructurada  
**✔️ Probado en:** Debian 12 (Bookworm) con GNOME

[1]: https://www.tecmint.com/install-nvidia-drivers-on-debian-12/
[2]: https://www.reddit.com/r/linux_gaming/comments/15z8j8v/guide_how_to_install_nvidia_drivers_on_debian_12/
[3]: https://phoenixnap.com/kb/debian-12-nvidia-driver
[4]: https://wiki.debian.org/NvidiaGraphicsDrivers
[5]: https://linuxconfig.org/how-to-install-nvidia-drivers-on-debian-12-bookworm
[6]: https://forums.developer.nvidia.com/c/gpu-graphics-linux/

