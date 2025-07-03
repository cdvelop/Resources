# Fallo de Reanulación de Suspensión y Problemas Derivados en HP Victus con Debian 12

## Entorno del Sistema

| Característica | Valor                                       |
| :--------------- | :------------------------------------------ |
| **Usuario**      | `cesar@laptop`                           |
| **SO**           | Debian GNU/Linux 12 (bookworm) x86_64       |
| **Host**         | Victus by HP Laptop 16-d0xxx                |
| **Kernel**       | 6.1.0-37-amd64                              |
| **Paquetes**     | 1559 (dpkg)                                 |
| **Shell**        | bash 5.2.15                                 |
| **Resolución**   | 1920x1080                                   |
| **Entorno DE**   | GNOME 43.9                                  |
| **Gestor WM**    | Mutter                                      |
| **Tema WM**      | Adwaita                                     |
| **Tema GTK**     | Adwaita [GTK2/3]                            |
| **Terminal**     | vscode                                      |
| **CPU**          | 11th Gen Intel i7-11800H (16) @ 4.600GHz    |
| **GPU Intel**    | Intel TigerLake-H GT1 [UHD Graphics]        |
| **GPU NVIDIA**   | NVIDIA GeForce RTX 3060 Mobile / Max-Q      |
| **Memoria**      | 2541MiB / 15624MiB                          |

## Descripción del Problema Principal (Causa Raíz)

El problema original y la causa raíz de todos los inconvenientes es que el sistema **no se reanuda correctamente después de entrar en modo de suspensión**. La pantalla se queda en negro, obligando al usuario a realizar un apagado forzado manteniendo presionado el botón de encendido.

Este apagado forzado provoca una cascada de problemas secundarios.

## Problemas Secundarios (Consecuencias del Apagado Forzado)

1.  **Posible Reactivación de Secure Boot:** Existe la hipótesis de que los apagados forzados o fallos críticos del sistema pueden provocar que la BIOS/UEFI revierta la configuración de "Secure Boot" a su estado predeterminado (activado).
2.  **Fallo de Carga del Controlador NVIDIA:** Con Secure Boot activado, el sistema operativo bloquea la carga de los módulos del kernel de NVIDIA no firmados, lo que deshabilita la GPU dedicada.
3.  **Pérdida de Salida de Vídeo HDMI:** Como consecuencia directa del fallo del controlador de NVIDIA, la salida de vídeo a través de HDMI deja de funcionar.
4.  **Corrupción de Perfiles de Navegador:** Al no cerrarse correctamente, las aplicaciones como Microsoft Edge o Chromium pueden corromper sus archivos de perfil, impidiendo que se inicien.

## Solución de los Problemas Secundarios (Contención)

Los siguientes pasos resuelven las consecuencias del apagado forzado, pero no el problema original de la suspensión.

### 1. Desactivar Secure Boot en la BIOS/UEFI

Esta es la solución para el fallo de carga del controlador de NVIDIA.

**a. Comprobar el estado:**

```bash
mokutil --sb-state
```

**b. Desactivar en la BIOS/UEFI:**

1.  Reiniciar el equipo y acceder a la configuración de la BIOS/UEFI (usualmente con **F10**, **Esc** o **F2** en portátiles HP).
2.  Navegar a la sección "Security", "Boot Options" o similar.
3
4.  Guardar los cambios y reiniciar.

### 2. Reparar Perfiles de Navegador Corruptos

**a. Diagnóstico (Ejemplo con Edge):**

```bash
microsoft-edge
```
El error indicará que el perfil está bloqueado.

**b. Solución:**

Eliminar los archivos de bloqueo del perfil (esto no borra los datos del usuario).

```bash
rm -f /home/cesar/.config/microsoft-edge/Singleton*
```

## Investigación de la Causa Raíz: Fallo en el Proceso de Suspensión

El siguiente paso es diagnosticar por qué el sistema no se reanuda correctamente. Los errores de ACPI vistos en los registros iniciales son ahora los principales sospechosos.

### Diagnóstico del Fallo de Suspensión

Tras resolver los problemas secundarios, la investigación se centra en la causa raíz: el fallo del sistema al reanudar desde el estado de suspensión.

#### Análisis de Logs de ACPI

El principal sospechoso es el subsistema ACPI (Advanced Configuration and Power Interface), responsable de la gestión de energía. Un análisis de los logs del kernel (`journalctl`) revela una gran cantidad de errores de la BIOS relacionados con ACPI.

```bash
sudo journalctl -b -1 | grep -i "ACPI"
```

Los errores más relevantes encontrados son:

- **Errores de resolución de símbolos y de objetos ya existentes:**
  ```
  ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.TXHC.RHUB.SS01], AE_NOT_FOUND
  ACPI BIOS Error (bug): Failure creating named object [\_SB.PC00.XHCI.RHUB.HS01._UPC], AE_ALREADY_EXISTS
  ```
  Estos errores indican que las tablas DSDT (Differentiated System Description Table) proporcionadas por la BIOS de HP están mal construidas. El kernel no puede encontrar objetos que se supone que existen o intenta crear objetos que ya han sido definidos, principalmente relacionados con los controladores USB (xHCI).

- **Error en la gestión de energía de la gráfica (NVIDIA):**
  ```
  ACPI: video: [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
  ```
  Este es un error crítico. Indica un bug en el firmware que afecta directamente al puerto gráfico PCI-Express (PEGP), donde está conectada la GPU de NVIDIA. La tabla ACPI define un método para enumerar los dispositivos de salida de video (`_DOD`) pero omite un método requerido para gestionar los cambios de estado de salida (`_DOS`). Esto puede impedir que el controlador de NVIDIA apague o reactive la pantalla correctamente durante el ciclo de suspensión/reanudación.

- **Desactivación de ASPM:**
  ```
  ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
  ```
  El kernel deshabilita el Ahorro de Energía de Estado Activo (ASPM) para los dispositivos PCIe porque la BIOS lo declara como no compatible. Esto reduce la eficiencia energética y puede ser un síntoma de una implementación ACPI incompleta o con errores.

Estos hallazgos sugieren fuertemente que el problema de la pantalla negra es causado por una **implementación defectuosa de ACPI en la BIOS/UEFI del HP Victus**, que impide al kernel y a los controladores de NVIDIA gestionar correctamente los estados de energía del hardware.

### Posibles Vías de Solución

1.  **Actualización de la BIOS/UEFI:** La solución más limpia sería actualizar la BIOS del portátil, con la esperanza de que HP haya corregido estos errores en una versión más reciente.
2.  **Parámetros de Arranque del Kernel:** Es posible mitigar los errores de ACPI pasando parámetros específicos al kernel en el arranque. Esto puede incluir "parches" para ignorar o modificar el comportamiento de ACPI.
3.  **Parchear DSDT:** Una solución avanzada que implica extraer las tablas ACPI, corregir los errores en el código AML (ACPI Machine Language) y cargarlas en el arranque, sobreescribiendo las de la BIOS.

La siguiente acción será investigar la disponibilidad de una actualización de la BIOS para este modelo de HP Victus.

### Comprobación de Actualización de BIOS/UEFI

Para verificar si existe una solución oficial por parte del fabricante, se procede a comprobar la versión de la BIOS instalada y a buscar actualizaciones.

**1. Obtener la versión actual de la BIOS:**

Se utiliza el comando `dmidecode` para leer la información del firmware.

```bash
sudo dmidecode -t bios
```

El resultado muestra la siguiente información:
- **Vendedor:** AMI
- **Versión:** F.26
- **Fecha de Lanzamiento:** 04/19/2024

**2. Búsqueda en el Sitio de Soporte de HP:**

Con el número de producto `62C37LA` (Victus by HP Laptop 16-d0515la), se ha realizado una búsqueda en el portal de soporte de HP.

**Resultado:** Se ha encontrado una versión de BIOS más reciente.

- **Versión Instalada:** `F.26` (del 19/04/2024)
- **Última Versión Disponible:** `F.29 Rev.A` (del 26/05/2025)

El historial de versiones no menciona explícitamente correcciones para ACPI o problemas de suspensión en Linux, centrándose en soporte para Windows y mejoras de seguridad. Sin embargo, una actualización de firmware es el paso más lógico para intentar solucionar los errores de bajo nivel detectados.

**Siguiente Acción:** Proceder con la actualización de la BIOS a la versión F.29 y verificar si el problema de suspensión se resuelve.

### Verificación Post-Actualización

**1. Confirmación de la Nueva Versión de BIOS**

Se ha actualizado la BIOS a la versión F.29. Una nueva comprobación con `dmidecode` confirma la actualización exitosa.

```bash
sudo dmidecode -t bios
```

- **Nueva Versión:** `F.29`
- **Nueva Fecha de Lanzamiento:** `04/11/2025`

**2. Análisis de Logs Post-Actualización**

Antes de probar la suspensión, se revisan nuevamente los logs del kernel para verificar si los errores de ACPI persisten.

```bash
sudo journalctl -b | grep -i "ACPI"
```

**Resultado:** Decepcionantemente, el análisis de los nuevos logs revela que **los errores de ACPI persisten**. Los mismos errores `AE_NOT_FOUND`, `AE_ALREADY_EXISTS` y, crucialmente, el `[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS` siguen presentes.

Esto indica que la actualización de la BIOS F.29 no ha corregido la implementación defectuosa de ACPI.

**3. Prueba de Suspensión**

A pesar de que los errores persisten en los logs, es necesario realizar la prueba de suspensión para confirmar si, a pesar de ellos, el comportamiento del sistema ha cambiado.

```bash
systemctl suspend
```

**Resultado:** **FALLIDO.** El problema persiste exactamente igual que antes. Tras reanudar, la pantalla se queda en negro, obligando a un apagado forzado. Al reiniciar, se comprueba que la BIOS ha vuelto a activar "Secure Boot" automáticamente, confirmando la hipótesis inicial sobre la causa de los problemas secundarios.

## Conclusión y Siguientes Pasos

La actualización de la BIOS a la versión F.29 **no ha resuelto el fallo de suspensión**. Los errores de ACPI persisten en los logs y el comportamiento del sistema no ha cambiado.

Dado que la vía de una solución por parte del fabricante (actualización de firmware) ha fallado, la siguiente estrategia es intentar que el sistema operativo (Linux) ignore o mitigue estos errores de la BIOS. Esto se puede lograr mediante **parámetros de arranque del kernel**.

### Estrategia de Mitigación: Pruebas con Parámetros de Arranque del Kernel

Se probarán diferentes parámetros de arranque del kernel, uno por uno, para aislar cuál de ellos (si alguno) tiene un efecto positivo.

#### Cómo Probar Parámetros de Forma Temporal

Para no hacer cambios permanentes en cada prueba, los parámetros se añadirán de forma temporal en el menú de arranque de GRUB:

1.  Reiniciar el ordenador.
2.  Cuando aparezca el menú de GRUB, presionar la tecla `e` para editar la entrada de arranque de Debian.
3.  Localizar la línea que empieza con `linux` (suele ser larga y terminar con `quiet splash`).
4.  Mover el cursor al final de esa línea y añadir el parámetro a probar (por ejemplo, `acpi_osi=Linux`).
5.  Presionar `Ctrl+X` o `F10` para arrancar con el parámetro añadido.
6.  Una vez en el sistema, realizar la prueba de suspensión (`systemctl suspend`), reanudar y verificar el resultado.

Este método es seguro, ya que el cambio solo dura para ese arranque.

#### Parámetros Candidatos a Probar

A continuación se listan los parámetros que se probarán, del más probable al menos probable, junto con la justificación de cada uno.

**1. `acpi_osi=` (Operating System Interface)**

-   **Parámetro a probar:** `acpi_osi='!Windows 2020'`
-   **Justificación:** Muchas BIOS tienen implementaciones de ACPI optimizadas o probadas únicamente para Windows. Este parámetro le dice a la BIOS "no soy la versión de Windows para la que tienes optimizaciones", lo que puede forzarla a usar un conjunto de funciones ACPI más genérico y estándar, evitando bugs específicos. Es uno de los remedios más comunes para problemas de ACPI en Linux. Si no funciona, se puede probar con `acpi_osi=Linux`.

**2. `acpi_rev_override=1`**

-   **Parámetro a probar:** `acpi_rev_override=1`
-   **Justificación:** Este parámetro fuerza al kernel a ignorar la versión de la especificación ACPI reportada por la BIOS. Si la BIOS reporta una versión pero su implementación no se adhiere correctamente a ella, este "override" puede solucionar conflictos.

**3. `nvme_core.default_ps_max_latency_us=5500`**

-   **Parámetro a probar:** `nvme_core.default_ps_max_latency_us=5500`
-   **Justificación:** A veces, el problema no está en la GPU sino en el dispositivo de almacenamiento NVMe, que no logra "despertar" a tiempo desde un estado de bajo consumo. Este parámetro limita la profundidad del estado de ahorro de energía del disco NVMe, haciéndolo menos propenso a fallar al reanudar. Un valor de 0 lo desactiva por completo, pero un valor intermedio como `5500` es un buen punto de partida.

**4. `nouveau.modeset=0`**

-   **Parámetro a probar:** `nouveau.modeset=0`
-   **Justificación:** Aunque se use el controlador propietario de NVIDIA, el controlador de código abierto `nouveau` puede cargarse en etapas tempranas del arranque e interferir con la gestión de energía. Este parámetro asegura que `nouveau` no intente gestionar el hardware gráfico (`modesetting`), dejando el control total al controlador de NVIDIA y evitando posibles conflictos durante la suspensión/reanudación.

La investigación se centrará ahora en encontrar y probar parámetros que puedan estar relacionados con los errores detectados, tales como:
- Parámetros para modificar la cadena `_OSI` (`acpi_osi=...`).
- Parámetros para forzar un comportamiento específico en la gestión de energía de PCIe o de la gráfica NVIDIA.
- Parámetros para ignorar ciertos errores de las tablas DSDT.
