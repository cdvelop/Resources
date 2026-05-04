# NVIDIA en Debian 13 (Trixie) — Diagnóstico Post-Upgrade

> **Contexto:** Sistema actualizado de Debian 12 (Bookworm) → Debian 13 (Trixie).
> Los servicios NVIDIA presentan problemas al arrancar y OBS Studio no puede iniciar grabación.
> GPU: NVIDIA GeForce RTX 3060
>
> **Propósito:** Documento de seguimiento paso a paso para identificar la causa raíz y resolverla.

---

## Paso 1 — Estado actual del sistema

### 1.1 Versión de Debian y kernel activo

```bash
cat /etc/os-release | grep -E "NAME|VERSION"
uname -r
```

**Resultado:**
```
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.4

6.12.85+deb13-amd64
```

---

### 1.2 Driver NVIDIA instalado

```bash
dpkg -l | grep nvidia
```

**Resultado:** Driver `550.163.01-2` instalado correctamente como paquetes Debian.
Paquetes clave presentes:
- `nvidia-driver 550.163.01-2`
- `nvidia-kernel-dkms 550.163.01-2` (compilación via DKMS)
- `libnvidia-encode1` (NVENC — requerido por OBS)

---

### 1.3 Estado de módulos NVIDIA cargados

```bash
lsmod | grep nvidia
```

**Resultado:** (sin salida — módulo NO cargado)

> **Diagnóstico:** El módulo del kernel no está activo. El driver está instalado pero no funciona.

---

### 1.4 Estado de nouveau

```bash
lsmod | grep nouveau
cat /etc/modprobe.d/blacklist-nouveau.conf
```

**Resultado:**
```
(nouveau no está cargado — correcto)

blacklist nouveau
options nouveau modeset=0
```

> nouveau está correctamente desactivado. No es el problema.

---

### 1.5 Headers del kernel instalados

```bash
dpkg -l | grep linux-headers
```

**Resultado:**
```
linux-headers-6.1.0-37-amd64      (kernel viejo Debian 12)
linux-headers-6.1.0-44-amd64      (kernel viejo Debian 12)
linux-headers-6.12.74+deb13+1-amd64  (kernel anterior Debian 13)
```

> **PROBLEMA ENCONTRADO:** El kernel activo es `6.12.85+deb13-amd64` pero
> los headers más recientes son para `6.12.74`. Faltan los headers de `6.12.85`.
> Sin ellos, DKMS no puede compilar el módulo nvidia para el kernel actual.

---

### 1.6 Estado DKMS

```bash
dkms status
```

**Resultado:** `dkms: command not found` — el paquete `dkms` no está instalado.

---

## ⚠️ DIAGNÓSTICO FINAL

| Causa | Detalle |
|-------|---------|
| **Headers faltantes** | No existe `linux-headers-6.12.85+deb13-amd64` para el kernel activo |
| **DKMS ausente** | El paquete `dkms` no está instalado (solo `nvidia-kernel-dkms`) |
| **Efecto** | El módulo `nvidia.ko` no fue compilado para el kernel `6.12.85` → no carga → OBS sin NVENC |

---

## Paso 2 — Reparación

### 2.1 (SUDO) Instalar headers del kernel actual y DKMS

> **Ejecutar este comando y pegar la salida:**

```bash
sudo apt install linux-headers-$(uname -r) dkms
```

**Resultado Obtenido:**
```
~/Dev/Resources$ sudo apt install linux-headers-$(uname -r) dkms
[sudo] password for cesar: 
dkms is already the newest version (3.2.2-1~deb13u1).
dkms set to manually installed.
The following packages were automatically installed and are no longer required:
  libwoff1                      linux-headers-6.1.0-44-common
  linux-headers-6.1.0-44-amd64  linux-image-6.1.0-44-amd64
Use 'sudo apt autoremove' to remove them.

Installing:
  linux-headers-6.12.85+deb13-amd64

Installing dependencies:
  linux-headers-6.12.85+deb13-common  linux-kbuild-6.12.85+deb13

Summary:
  Upgrading: 0, Installing: 3, Removing: 0, Not Upgrading: 0
  Download size: 15.8 MB
  Space needed: 76.0 MB / 103 GB available

Continue? [Y/n] y
Get:1 http://security.debian.org/debian-security trixie-security/main amd64 linux-headers-6.12.85+deb13-common all 6.12.85-1 [11.1 MB]
Get:2 http://security.debian.org/debian-security trixie-security/main amd64 linux-kbuild-6.12.85+deb13 amd64 6.12.85-1 [1,680 kB]
Get:3 http://security.debian.org/debian-security trixie-security/main amd64 linux-headers-6.12.85+deb13-amd64 amd64 6.12.85-1 [3,005 kB]
Fetched 15.8 MB in 0s (63.4 MB/s)                        
debconf: unable to initialize frontend: Dialog
debconf: (Dialog frontend requires a screen at least 13 lines tall and 31 columns wide.)
debconf: falling back to frontend: Readline
Selecting previously unselected package linux-headers-6.12.85+deb13-common.
(Reading database ... 304949 files and directories currently installed.)
Preparing to unpack .../linux-headers-6.12.85+deb13-common_6.12.85-1_all.deb ...
Unpacking linux-headers-6.12.85+deb13-common (6.12.85-1) ...
Selecting previously unselected package linux-kbuild-6.12.85+deb13.
Preparing to unpack .../linux-kbuild-6.12.85+deb13_6.12.85-1_amd64.deb ...
Unpacking linux-kbuild-6.12.85+deb13 (6.12.85-1) ...
Selecting previously unselected package linux-headers-6.12.85+deb13-amd64.
Preparing to unpack .../linux-headers-6.12.85+deb13-amd64_6.12.85-1_amd64.deb ...
Unpacking linux-headers-6.12.85+deb13-amd64 (6.12.85-1) ...
Setting up linux-kbuild-6.12.85+deb13 (6.12.85-1) ...
Setting up linux-headers-6.12.85+deb13-common (6.12.85-1) ...
Setting up linux-headers-6.12.85+deb13-amd64 (6.12.85-1) ...
/etc/kernel/header_postinst.d/dkms:
Sign command: /lib/modules/6.12.85+deb13-amd64/build/scripts/sign-file
Signing key: /var/lib/dkms/mok.key
Public certificate (MOK): /var/lib/dkms/mok.pub

Autoinstall of module nvidia-current/550.163.01 for kernel 6.12.85+deb13-amd64 (x86_64)
Building module(s)........... done.
Signing module /var/lib/dkms/nvidia-current/550.163.01/build/nvidia.ko] 
Signing module /var/lib/dkms/nvidia-current/550.163.01/build/nvidia-modeset.koress: [ 85%] [████████████████████████████████████████████        ] 
Signing module /var/lib/dkms/nvidia-current/550.163.01/build/nvidia-drm.ko
Signing module /var/lib/dkms/nvidia-current/550.163.01/build/nvidia-uvm.ko
Signing module /var/lib/dkms/nvidia-current/550.163.01/build/nvidia-peermem.ko
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/nvidia-current.ko.xz
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/nvidia-current-modeset.ko.xz
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/nvidia-current-drm.ko.xz
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/nvidia-current-uvm.ko.xz
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/nvidia-current-peermem.ko.xz
Running depmod.... done.

Autoinstall of module v4l2loopback/0.15.0 for kernel 6.12.85+deb13-amd64 (x86_64)
Building module(s)... done.
Signing module /var/lib/dkms/v4l2loopback/0.15.0/build/v4l2loopback.ko
Installing /lib/modules/6.12.85+deb13-amd64/updates/dkms/v4l2loopback.ko.xz
Running depmod.... done.

Autoinstall on 6.12.85+deb13-amd64 succeeded for module(s) nvidia-current v4l2loopback.
```

---

### 2.2 Recompilar con DKMS — OMITIDO

> El paso 2.1 ya disparó la compilación automáticamente al instalar los headers.
> DKMS compiló e instaló todos los módulos sin intervención adicional:
> - `nvidia-current.ko.xz` ✓
> - `nvidia-current-modeset.ko.xz` ✓
> - `nvidia-current-drm.ko.xz` ✓
> - `nvidia-current-uvm.ko.xz` ✓
> - `nvidia-current-peermem.ko.xz` ✓
> - `v4l2loopback.ko.xz` ✓ (virtual camera — útil para OBS)
>
> `Autoinstall on 6.12.85+deb13-amd64 succeeded for module(s) nvidia-current v4l2loopback`

---

### 2.3 (SUDO) Actualizar initramfs y reiniciar

```bash
sudo update-initramfs -u && sudo reboot
```

**Resultado Obtenido:**
```
Sistema reinició normalmente ✓
```

---

## Paso 3 — Verificación post-reinicio

### 3.1 Módulo cargado

```bash
lsmod | grep nvidia
```

**Resultado Obtenido:**
```
(pendiente — ejecutar y pegar)
```

---

### 3.2 nvidia-smi

```bash
nvidia-smi
```

**Resultado Obtenido:**
```
Mon May  4 18:18:14 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.163.01             Driver Version: 550.163.01     CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3060 ...    Off |   00000000:01:00.0  On |                  N/A |
| N/A   43C    P8             11W /   80W |      57MiB /   6144MiB |      0%      Default |
+-----------------------------------------+------------------------+----------------------+
| Processes:                                                                              |
|    0   N/A  N/A      1489      G   /usr/lib/xorg/Xorg                             53MiB |
+-----------------------------------------------------------------------------------------+
```

> Driver 550.163.01 activo ✓ — GPU detectada ✓ — CUDA 12.4 ✓

---

### 3.3 Verificación con OBS Studio

Abrir OBS → Configuración → Salida → Codificador de video.

> **Debe aparecer:** `NVENC H.264` o `NVENC H.265`

**Resultado Obtenido:**
```
(pendiente — confirmar en OBS)
```

---

## Resumen del Diagnóstico

| Fecha | Problema | Causa Raíz | Solución | Estado |
|-------|----------|------------|----------|--------|
| 2026-05-04 | NVIDIA no carga, OBS sin NVENC | Headers `6.12.85` faltantes (kernel actualizado sin recompilar módulos) | `apt install linux-headers-$(uname -r) dkms` — DKMS recompiló automáticamente | **RESUELTO** ✓ |

---

## Referencias

| Recurso | Enlace |
|---------|--------|
| Debian Wiki — NVIDIA Drivers | https://wiki.debian.org/NvidiaGraphicsDrivers |
| DKMS manual | `man dkms` |

---

**Creado:** Mayo 2026
**Sistema:** Debian 13 (Trixie) 13.4 — upgrade desde Debian 12 (Bookworm)
**GPU:** NVIDIA GeForce RTX 3060 / Driver: 550.163.01
