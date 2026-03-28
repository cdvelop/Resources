# Errores ACPI/BIOS al arrancar — HP Victus 16-d0xxx

Fecha de diagnóstico: 2026-03-28
Hardware: HP Victus by HP Laptop 16-d0xxx
BIOS: F.29 (04/11/2025)
Kernel: 6.12.74+deb13+1-amd64

Comando para reproducir:
```bash
sudo dmesg --level=err,warn | grep -iv "nouveau\|nvidia\|drm\|xhci\|usb\|bluetooth\|iwl\|wlan\|nft\|iptables"
```

---

## Resumen

| # | Error | Severidad | Acción |
|---|-------|-----------|--------|
| 1 | ACPI USB hub duplicados (AE_ALREADY_EXISTS) | Cosmético | Ninguna |
| 2 | ACPI TXHC SS01-SS04 no encontrados | Cosmético | Ninguna |
| 3 | HP WMID buffer limit / hp_bioscfg falla | Media | Actualizar BIOS |
| 4 | ACPI thermal threshold inválido | Cosmético | Ninguna |
| 5 | ACPI video PEGP sin _DOS | Cosmético | Ninguna |
| 6 | ASPM sin control del OS | Baja | Ninguna por ahora |
| 7 | i8042 PS/2 AUX port disabled | Baja | Solo si el touchpad falla |
| 8 | Kernel taint por NVIDIA | Esperado | Ninguna |
| 9 | kdeconnectd wireless extensions | Baja | Futura actualización |

---

## 1. ACPI USB hub — AE_ALREADY_EXISTS (cosmético)

### Mensajes
```
ACPI BIOS Error (bug): Failure creating named object [\_SB.PC00.XHCI.RHUB.HS01._UPC], AE_ALREADY_EXISTS
... (se repite para HS01–HS14 y SS01–SS06)
```

### Diagnóstico
El BIOS de HP define los puertos del hub USB (XHCI.RHUB) dos veces en las tablas
ACPI: una vez en el DSDT principal y otra en un SSDT secundario. Linux detecta la
duplicación y descarta las definiciones repetidas. Los puertos USB **funcionan
correctamente**.

### Causa
Bug en el firmware HP. Las tablas ACPI fueron diseñadas para Windows, que ignora
estas duplicaciones. El kernel Linux es más estricto al validarlas.

### Estado
No tiene solución desde Linux. Solo HP puede corregirlo con una actualización de BIOS.
Presente también en Debian 12, se arrastró al upgrade.

---

## 2. ACPI TXHC SS01-SS04 — AE_NOT_FOUND (cosmético)

### Mensajes
```
ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.TXHC.RHUB.SS01], AE_NOT_FOUND
ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.TXHC.RHUB.SS02], AE_NOT_FOUND
ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.TXHC.RHUB.SS03], AE_NOT_FOUND
ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.TXHC.RHUB.SS04], AE_NOT_FOUND
```

### Diagnóstico
El controlador Thunderbolt (TXHC) hace referencia a puertos SuperSpeed (SS01-SS04)
que no están definidos en las tablas ACPI. Relacionado con el bug #1 — las definiciones
duplicadas del XHCI interfieren con las referencias del TXHC.
El Thunderbolt **funciona correctamente** a pesar del error.

### Estado
Bug de BIOS HP. Sin acción posible desde Linux.

---

## 3. HP WMID buffer limit / hp_bioscfg (media)

### Mensajes
```
ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Index (0x000000032) is beyond end of object (length 0x32)
ACPI Error: Aborting method \_SB.WMID.WQBZ due to previous error
ACPI Error: Aborting method \_SB.WMID.WQBE due to previous error
hp_bioscfg: Returned error 0x3, "Invalid command value/Feature not supported"
```

### Diagnóstico
El método ACPI `\_SB.WMID` (HP WMI interface) intenta acceder al índice 50 (0x32)
de un buffer de longitud exactamente 50 — error de off-by-one en el firmware HP.
Como consecuencia, el driver `hp_bioscfg` no puede leer/escribir configuración
del BIOS desde Linux (umbrales de batería, fan control via HP tools, etc.).

Las **funciones básicas del hardware funcionan** (la gestión de energía la maneja
el kernel directamente). Lo que no funciona es la configuración avanzada HP-específica
a través de `/sys/bus/platform/drivers/hp-bioscfg/`.

### Estado
Verificado 2026-03-28 — BIOS F.29 (04/11/2025) es la versión más reciente disponible.
Los bugs ACPI (AE_AML_BUFFER_LIMIT, hp_bioscfg) son conocidos en la comunidad HP
pero no tienen fix confirmado en ninguna versión de BIOS publicada.
Sin acción posible por ahora. Revisar periódicamente en:
https://support.hp.com → modelo 16-d0xxx → Firmware

---

## 4. ACPI thermal threshold inválido (cosmético)

### Mensaje
```
ACPI: thermal: [Firmware Bug]: Invalid critical threshold (-274000)
```

### Diagnóstico
El BIOS reporta un umbral de temperatura crítica de -274°C (prácticamente 0 Kelvin),
que es físicamente imposible. Linux detecta el valor inválido y lo ignora, usando
sus propios valores por defecto para la gestión térmica.
La temperatura del sistema **se monitorea y gestiona correctamente**.

### Verificar temperatura real
```bash
sensors
# o
cat /sys/class/thermal/thermal_zone*/temp
```

### Estado
Bug de BIOS HP. Sin impacto real. Sin acción requerida.

---

## 5. ACPI video PEGP sin _DOS (cosmético)

### Mensaje
```
ACPI: video: [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
```

### Diagnóstico
La GPU discreta NVIDIA (PEGP = PCI Express Graphics Port) declara los outputs de
pantalla disponibles (`_DOD`) pero no implementa el método de switching de displays
(`_DOS`). Esto es normal en laptops con gráficos híbridos Intel+NVIDIA (Optimus).
El driver NVIDIA gestiona el switching directamente sin necesitar `_DOS`.

### Estado
Cosmético en sistemas con Optimus. Sin acción requerida.

---

## 6. ASPM sin control del OS (baja)

### Mensajes
```
r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
pci 10000:e1:00.0: can't override BIOS ASPM; OS doesn't have ASPM control
```

### Diagnóstico
ASPM (Active State Power Management) controla el consumo de energía de dispositivos
PCIe en estados de baja actividad. El BIOS de HP no cede el control de ASPM al OS,
por lo que Linux no puede optimizarlo. Impacto: consumo de batería ligeramente
subóptimo, inapreciable en uso normal.

### Estado
Sin acción requerida. Si se detecta consumo de batería anormalmente alto, investigar
con `powertop`.

---

## 7. i8042 PS/2 AUX port disabled (baja)

### Mensaje
```
i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
```

### Diagnóstico
El ACPI PnP reporta el puerto PS/2 AUX (habitualmente el touchpad) como deshabilitado.
Linux lo detecta y advierte. En la mayoría de laptops HP el touchpad funciona
igualmente vía I2C/HID, no PS/2.

### Acción (solo si el touchpad falla)
Agregar al kernel en `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet i8042.nopnp"
```
Luego:
```bash
sudo update-grub
```

### Estado
Sin acción requerida salvo problemas con el touchpad.

---

## 8. Kernel taint por NVIDIA (esperado)

### Mensaje
```
Disabling lock debugging due to kernel taint
```

### Diagnóstico
El módulo propietario de NVIDIA "tainta" el kernel (lo marca como modificado con
código no-libre). Esto deshabilita algunas herramientas de debugging del kernel.
Es el comportamiento esperado con el driver NVIDIA propietario instalado.

### Estado
Normal. Sin acción requerida.

---

## 9. kdeconnectd wireless extensions (baja / futura)

### Mensaje
```
warning: `kdeconnectd' uses wireless extensions which will stop working for Wi-Fi 7 hardware
```

### Diagnóstico
KDE Connect usa la API `wireless extensions` (wext) que está deprecada. Funcionará
con el hardware Wi-Fi actual pero dejará de funcionar con hardware Wi-Fi 7 (802.11be).
El hardware actual no es Wi-Fi 7, por lo que no hay impacto inmediato.

### Acción futura
Actualizar KDE Connect cuando haya versión disponible que use `nl80211`.
```bash
apt-cache policy kdeconnect
```

### Estado
Sin acción requerida actualmente.

---

## Diagnóstico rápido

```bash
# Ver todos los errores/warnings del kernel (sin ruido de drivers)
sudo dmesg --level=err,warn | grep -iv "nouveau\|nvidia\|drm\|xhci\|usb\|bluetooth\|iwl\|wlan\|nft\|iptables"

# Ver errores ACPI específicos
sudo dmesg | grep -iE "acpi.*error|acpi.*warn|firmware.*bug"

# Ver versión del BIOS
sudo dmidecode -s bios-version && sudo dmidecode -s bios-release-date

# Monitorear temperaturas
sensors
```
