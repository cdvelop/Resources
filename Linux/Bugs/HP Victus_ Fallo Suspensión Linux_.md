# **Fallo de Reanulación de Suspensión y Problemas Derivados en HP Victus con Debian 12**

## **Resumen Ejecutivo**

El presente informe detalla un problema crítico de reanudación del sistema en un portátil HP Victus 16-d0xxx con Debian 12\. El fallo primario se manifiesta como una pantalla negra al intentar reanudar desde el modo de suspensión, lo que obliga al usuario a realizar un apagado forzado. Este comportamiento desencadena una serie de problemas secundarios, incluyendo la reactivación de Secure Boot, la consecuente inoperatividad del controlador NVIDIA y la pérdida de la salida HDMI, además de la corrupción de perfiles de navegador.

La investigación profunda ha identificado la causa raíz en deficiencias fundamentales de la implementación del firmware ACPI (Advanced Configuration and Power Interface) en la BIOS de HP. Estos errores persisten incluso tras la actualización a la versión F.29 de la BIOS, lo que subraya una falta de compatibilidad oficial o una implementación defectuosa por parte del fabricante. Se propone un enfoque multifacético para abordar el problema, que incluye ajustes de parámetros del kernel, una gestión cuidadosa de los controladores NVIDIA y, en última instancia, la posible aplicación de parches avanzados en la tabla DSDT. El objetivo es restaurar una funcionalidad de suspensión fiable o, en su defecto, optimizar el estado de suspensión s2idle si el modo deep (S3) no es viable.

## **Entorno del Sistema y Declaración del Problema**

El sistema afectado es un portátil **HP Victus 16-d0xxx** con las siguientes especificaciones:

| Característica | Valor |
| :---- | :---- |
| **Usuario** | cesar@laptop |
| **SO** | Debian GNU/Linux 12 (bookworm) x86\_64 |
| **Host** | Victus by HP Laptop 16-d0xxx |
| **Kernel** | 6.1.0-37-amd64 |
| **Paquetes** | 1559 (dpkg) |
| **Shell** | bash 5.2.15 |
| **Resolución** | 1920x1080 |
| **Entorno DE** | GNOME 43.9 |
| **Gestor WM** | Mutter |
| **Tema WM** | Adwaita |
| **Tema GTK** | Adwaita |
| **Terminal** | vscode |
| **CPU** | 11th Gen Intel i7-11800H (16) @ 4.600GHz |
| **GPU Intel** | Intel TigerLake-H GT1 |
| **GPU NVIDIA** | NVIDIA GeForce RTX 3060 Mobile / Max-Q |
| **Memoria** | 2541MiB / 15624MiB |

El problema principal y recurrente es que el sistema **no se reanuda correctamente después de entrar en modo de suspensión**. Al intentar reactivar el portátil, la pantalla permanece completamente en negro, sin respuesta alguna a las entradas del teclado o el ratón. Esta situación obliga al usuario a realizar un apagado forzado manteniendo presionado el botón de encendido.1 Este comportamiento es consistente con problemas reportados en otros modelos HP Victus y portátiles con configuraciones de hardware similares bajo Linux.3

Este apagado forzado no solo interrumpe el flujo de trabajo, sino que también provoca una cascada de problemas secundarios:

1. **Posible Reactivación de Secure Boot:** Se ha observado que los apagados forzados o fallos críticos del sistema pueden llevar a que la BIOS/UEFI revierta la configuración de "Secure Boot" a su estado predeterminado (activado).  
2. **Fallo de Carga del Controlador NVIDIA:** Con Secure Boot activado y sin los módulos del kernel de NVIDIA firmados adecuadamente (o sin el registro de MOK), el sistema operativo bloquea la carga de estos módulos. Esto inhabilita la GPU dedicada NVIDIA.  
3. **Pérdida de Salida de Vídeo HDMI:** Como consecuencia directa de la inoperatividad del controlador NVIDIA, la salida de vídeo a través del puerto HDMI deja de funcionar, ya que este puerto suele estar conectado a la GPU dedicada.  
4. **Corrupción de Perfiles de Navegador:** La interrupción abrupta de la energía impide que las aplicaciones, como Microsoft Edge o Chromium, cierren sus procesos correctamente. Esto puede resultar en la corrupción de sus archivos de perfil, impidiendo que se inicien en futuros arranques.

La secuencia de problemas observada, desde el fallo de suspensión hasta la corrupción de perfiles de navegador, revela una clara cadena causal. La incapacidad del sistema para reanudar la suspensión de manera controlada es el evento desencadenante que fuerza un reinicio abrupto. Este reinicio no solo interrumpe las operaciones en curso, sino que también puede alterar la configuración de la BIOS (como Secure Boot) y dañar datos de aplicaciones. Por lo tanto, la resolución del problema principal de suspensión es fundamental para mitigar todos los inconvenientes secundarios, ya que estos son meras consecuencias de una gestión energética deficiente.

## **Análisis Profundo: Deficiencias del Firmware ACPI**

La investigación de la causa raíz del fallo de suspensión se ha centrado en el subsistema ACPI (Advanced Configuration and Power Interface). ACPI es un estándar industrial crucial que define la interfaz entre el sistema operativo y el firmware del hardware para la gestión de energía, la configuración de dispositivos y los estados de suspensión.28 Su correcta implementación es vital para que las funciones de suspensión y reanudación operen sin problemas.

El análisis de los registros del kernel (journalctl) ha revelado una serie de errores recurrentes de la BIOS relacionados con ACPI, los cuales son los principales sospechosos del comportamiento anómalo.

### **Desglose Detallado de los Errores de la BIOS ACPI Observados**

Los errores más relevantes encontrados en los registros del kernel son:

* **Errores de resolución de símbolos y de objetos ya existentes:**  
  ACPI BIOS Error (bug): Could not resolve symbol, AE\_NOT\_FOUND  
  ACPI BIOS Error (bug): Failure creating named object, AE\_ALREADY\_EXISTS

  Estos mensajes indican que las tablas DSDT (Differentiated System Description Table) proporcionadas por la BIOS de HP están mal construidas o son inconsistentes.2 El kernel de Linux no puede encontrar objetos que se supone que existen (  
  AE\_NOT\_FOUND) o intenta crear objetos que ya han sido definidos (AE\_ALREADY\_EXISTS). Estos errores se relacionan principalmente con los controladores USB (xHCI). Si bien estos errores a veces pueden ser benignos y no causar problemas directos, su presencia general sugiere una implementación de ACPI que no cumple plenamente con los estándares. Esto puede llevar a un comportamiento impredecible en la gestión de energía y otros subsistemas. La persistencia de estos errores, incluso después de una actualización de la BIOS, apunta a un problema sistémico en la calidad del firmware de HP. Esto sugiere que el desarrollo de la BIOS de HP, al menos para esta serie Victus, no prioriza la compatibilidad con Linux o contiene fallos fundamentales no resueltos en su implementación de ACPI.  
* **Error en la gestión de energía de la gráfica (NVIDIA):**  
  ACPI: video:: ACPI(PEGP) defines \_DOD but not \_DOS

  Este es un error crítico que afecta directamente al puerto gráfico PCI-Express (PEGP), donde está conectada la GPU de NVIDIA.3 La especificación ACPI define dos métodos clave para la gestión de la pantalla en sistemas con gráficos híbridos:  
  * \_DOD (Enumerate All Devices Attached to the Display Adapter): Este método se utiliza para enumerar todos los dispositivos de salida de vídeo conectados al adaptador de pantalla.29  
  * \_DOS (Enable/Disable Output Switching): Este método es necesario si el sistema soporta la conmutación de pantalla o el control de brillo LCD.29 Permite que el firmware controle la salida de pantalla activa o el brillo.

    La presencia de \_DOD sin \_DOS indica un fallo en el firmware de la BIOS que impide que el controlador de NVIDIA apague o reactive la pantalla correctamente durante el ciclo de suspensión/reanudación.39 En sistemas con gráficos híbridos (como el HP Victus con Intel iGPU y NVIDIA dGPU), el kernel necesita un control preciso sobre qué GPU está activa y cómo se gestionan las salidas de pantalla durante las transiciones de energía. La ausencia de  
    \_DOS significa que la BIOS no proporciona el mecanismo ACPI necesario para que el sistema operativo controle adecuadamente los cambios de estado de la pantalla. Esta situación crea un conflicto directo entre la forma en que el hardware espera ser controlado por el firmware y los requisitos del kernel de Linux para una gestión energética y de pantalla robusta, lo que se traduce directamente en el problema de la pantalla negra al reanudar.  
* **Desactivación de ASPM:**  
  ACPI FADT declares the system doesn't support PCIe ASPM, so disable it

  El kernel deshabilita el Ahorro de Energía de Estado Activo (ASPM) para los dispositivos PCIe porque la BIOS lo declara como no compatible. ASPM permite que los enlaces PCIe entren en estados de baja energía cuando están inactivos, mejorando la eficiencia energética. Esta desactivación no solo reduce la eficiencia energética del sistema, sino que también es otro síntoma de una implementación ACPI incompleta o con errores por parte de HP, lo que refuerza el diagnóstico de problemas generales de gestión de energía.

La siguiente tabla resume los errores ACPI identificados y su impacto:

| Error Identificado | Significado Técnico | Impacto Directo |
| :---- | :---- | :---- |
| ACPI BIOS Error (bug): Could not resolve symbol \[...\] AE\_NOT\_FOUND | Tablas DSDT/ACPI malformadas; el kernel no encuentra objetos esperados. | Indica una implementación ACPI no conforme, potencial inestabilidad y comportamiento impredecible en la gestión de energía. |
| ACPI BIOS Error (bug): Failure creating named object \[...\] AE\_ALREADY\_EXISTS | Tablas DSDT/ACPI malformadas; el kernel intenta crear objetos ya definidos. | Indica una implementación ACPI no conforme, potencial inestabilidad y comportamiento impredecible en la gestión de energía. |
| ACPI: video:: ACPI(PEGP) defines \_DOD but not \_DOS | La BIOS define la enumeración de dispositivos de pantalla (\_DOD) pero carece del método para el control de salida de pantalla (\_DOS). | Impide que el controlador NVIDIA gestione correctamente el estado de la pantalla durante la suspensión/reanudación, lo que lleva a la pantalla negra. Crítico para gráficos híbridos. |
| ACPI FADT declares the system doesn't support PCIe ASPM, so disable it | La BIOS declara que el Ahorro de Energía de Estado Activo (ASPM) de PCIe no es compatible. | Reduce la eficiencia energética; síntoma adicional de una implementación ACPI incompleta. |

Estos hallazgos sugieren fuertemente que el problema de la pantalla negra es causado por una implementación defectuosa de ACPI en la BIOS/UEFI del HP Victus, que impide al kernel y a los controladores de NVIDIA gestionar correctamente los estados de energía del hardware.

## **Impacto de la Actualización de la BIOS F.29**

La actualización de la BIOS del portátil a la versión F.29 (con fecha de lanzamiento 04/11/2025) fue un paso lógico para intentar resolver los errores de bajo nivel detectados. Sin embargo, tras la actualización y una nueva revisión de los registros del kernel, se constató que **los errores de ACPI persisten** \[User Query\]. Los mismos mensajes de AE\_NOT\_FOUND, AE\_ALREADY\_EXISTS y, crucialmente, : ACPI(PEGP) defines \_DOD but not \_DOS siguen presentes. Además, la prueba de suspensión posterior a la actualización resultó fallida, con la pantalla quedándose en negro y forzando un apagado, lo que a su vez reactivó Secure Boot.

La persistencia de estos problemas fundamentales de ACPI a pesar de una actualización de la BIOS tiene implicaciones significativas para el soporte del fabricante. Numerosas fuentes indican que los portátiles HP Victus a menudo presentan un soporte deficiente para la suspensión en Linux, con BIOS diseñadas principalmente para el Modern Standby (S0ix) de Windows y careciendo de opciones para el estado de suspensión deep (S3).5 Las páginas de soporte oficiales de HP también se centran predominantemente en Windows.42 Esta situación revela una tendencia general de apatía del fabricante hacia la compatibilidad con Linux. La experiencia del usuario, donde una actualización de BIOS reciente no abordó los problemas centrales de ACPI, refuerza la conclusión de que los usuarios de Linux no pueden depender de las actualizaciones oficiales de firmware para resolver estos desafíos específicos de gestión de energía. Esto implica que la resolución requerirá soluciones a nivel del sistema operativo.

## **Estrategias Avanzadas de Remediación y Solución de Problemas**

Dado que las actualizaciones de la BIOS no han resuelto los problemas fundamentales de ACPI, es necesario explorar estrategias de remediación más avanzadas a nivel del sistema operativo.

### **Ajustes de Parámetros del Kernel**

La modificación de los parámetros de arranque del kernel es una vía prometedora para mitigar los errores de ACPI y mejorar la funcionalidad de suspensión.

* acpi\_osi=Windows XXXX  
  Este parámetro intenta "engañar" a la BIOS para que crea que se está ejecutando una versión específica de Windows. El propósito es activar funcionalidades ACPI adicionales o soluciones alternativas que la BIOS podría ocultar o deshabilitar para sistemas operativos que no sean Windows.28 Muchas implementaciones de BIOS exponen la funcionalidad completa de gestión de energía solo cuando detectan un sistema operativo Windows. Este ajuste es una adaptación a nivel del sistema operativo para compensar las deficiencias del firmware.  
  Para identificar el valor XXXX más adecuado, se recomienda inspeccionar la tabla DSDT en busca de versiones de Windows reconocidas por el firmware:  
  Bash  
  sudo strings /sys/firmware/acpi/tables/DSDT | grep \-i windows

  Se debe elegir la versión de Windows más reciente que aparezca en la salida (por ejemplo, Windows 2022, Windows 2020).  
  **Aplicación:**  
  * **Prueba Temporal:** Durante el menú de arranque de GRUB, presione e, navegue hasta la línea que comienza con linux y añada acpi\_osi="Windows XXXX" (por ejemplo, acpi\_osi="Windows 2022") al final. Presione Ctrl+X o F10 para arrancar con este cambio.48  
  * **Aplicación Permanente:** Edite el archivo /etc/default/grub. Busque la línea GRUB\_CMDLINE\_LINUX\_DEFAULT="quiet splash" y añada el parámetro dentro de las comillas, escapando las comillas internas si es necesario (por ejemplo, GRUB\_CMDLINE\_LINUX\_DEFAULT="quiet splash acpi\_osi=\\"Windows 2022\\""). Luego, ejecute sudo update-grub y reinicie el sistema.48

La efectividad de este parámetro puede variar con las versiones del kernel y las revisiones específicas de la BIOS.44 Es una solución pragmática para la falta de cumplimiento del proveedor, pero no una corrección del error de la BIOS en sí.

* intel\_idle.max\_cstate=X  
  Este parámetro controla el estado C (estado de energía inactivo de la CPU) más profundo al que se permite entrar a la CPU Intel.31 Los estados C más profundos ahorran más energía, pero pueden tener latencias de salida más altas o, en el caso de firmware defectuoso, impedir una reanudación fiable. Limitar el estado C máximo puede evitar que la CPU entre en estados de los que no puede reanudarse de forma fiable. Un usuario con un modelo HP Victus similar y una CPU Intel encontró éxito con  
  intel\_idle.max\_cstate=4.8 Es importante señalar que  
  max\_cstate=0 a menudo se traduce internamente a max\_cstate=1.35 Esta medida busca mitigar los fallos de suspensión específicos de la CPU, que pueden ser independientes de los problemas generales de ACPI pero a menudo se ven exacerbados por ellos.  
  **Aplicación:** Añada intel\_idle.max\_cstate=4 (o 1\) a GRUB\_CMDLINE\_LINUX\_DEFAULT en /etc/default/grub y ejecute sudo update-grub.32  
  Esta configuración puede aumentar ligeramente el consumo de energía en reposo, ya que la CPU no entrará en sus estados de sueño más profundos, pero prioriza la fiabilidad de la reanudación.  
* Forzar mem\_sleep\_default=deep  
  Los portátiles modernos a menudo soportan el modo de suspensión s2idle (Modern Standby / S0ix), donde el sistema permanece en un estado de baja energía pero sigue activo, lo que puede provocar un mayor consumo de batería y posibles problemas de reanudación.5  
  deep (Suspend-to-RAM / S3) es el estado de suspensión tradicional, más eficiente energéticamente, que Linux suele preferir para una funcionalidad completa. Se ha informado con frecuencia que los modelos HP Victus solo soportan s2idle o carecen de opciones de BIOS para deep.5 Esto representa una limitación de hardware significativa para los usuarios de Linux.  
  Para verificar los estados de suspensión disponibles:  
  Bash  
  cat /sys/power/mem\_sleep

  La salida mostrará los estados soportados (por ejemplo, \[s2idle\] shallow deep). El estado entre corchetes es el actualmente activo.56  
  **Aplicación:** Para intentar forzar la suspensión deep:  
  * **Temporal:** echo deep | sudo tee /sys/power/mem\_sleep.26  
  * **Permanente:** Añada mem\_sleep\_default=deep a GRUB\_CMDLINE\_LINUX\_DEFAULT en /etc/default/grub y ejecute sudo update-grub.10

Si la BIOS realmente no soporta S3, forzar deep podría no funcionar o provocar inestabilidad. En tal caso, el enfoque se desplazaría a la optimización de s2idle.

* **Otros Parámetros del Kernel (con precaución)**  
  * nomodeset: Deshabilita el kernel mode setting para gráficos. Puede resolver problemas de visualización durante el arranque/reanudación, pero puede resultar en una resolución más baja o falta de aceleración gráfica. Generalmente, no es una solución a largo plazo.37  
  * acpi=off: Deshabilita todo el subsistema ACPI. Esta es una medida drástica que impedirá toda la gestión de energía, lo que podría conducir a un alto consumo de energía, sobrecalentamiento y pérdida de funcionalidad (por ejemplo, estado de la batería, control del ventilador). Solo debe considerarse para depuración extrema si ninguna otra solución funciona.37

La siguiente tabla resume los parámetros del kernel recomendados para problemas de suspensión/reanudación:

| Parámetro | Propósito | Sintaxis (GRUB\_CMDLINE\_LINUX\_DEFAULT) | Efecto Esperado | Advertencias |
| :---- | :---- | :---- | :---- | :---- |
| acpi\_osi="Windows XXXX" | Engaña a la BIOS para habilitar la funcionalidad ACPI completa para Windows. | acpi\_osi=\\"Windows 2022\\" (o 2020, según la salida de DSDT) | Puede resolver problemas de suspensión relacionados con ACPI al habilitar funciones de la BIOS. | La efectividad varía; podría requerir reevaluación con actualizaciones del kernel/BIOS. |
| intel\_idle.max\_cstate=4 | Limita la CPU a estados inactivos menos profundos, previniendo bloqueos de los estados C más profundos. | intel\_idle.max\_cstate=4 | Mejora la fiabilidad de la reanudación; ligero aumento en el consumo de energía en reposo. | Puede no ser necesario si la suspensión se resuelve por otros medios. |
| mem\_sleep\_default=deep | Fuerza al sistema a usar Suspend-to-RAM (S3) para un mayor ahorro de energía. | mem\_sleep\_default=deep | Suspensión más eficiente; puede fallar si la BIOS realmente carece de soporte S3. | Verificar /sys/power/mem\_sleep primero. Si deep no está disponible, optimizar s2idle. |

### **Gestión del Controlador NVIDIA**

Los controladores propietarios de NVIDIA incluyen servicios de systemd (nvidia-suspend.service, nvidia-hibernate.service, nvidia-resume.service) que gestionan los estados de energía de la GPU durante la suspensión/reanudación. Estos servicios a veces pueden entrar en conflicto con la gestión de energía del kernel o contener errores, lo que lleva a pantallas negras o falta de respuesta del sistema al reanudar.3 Esta necesidad de deshabilitar los servicios de NVIDIA indica un conflicto en la responsabilidad de la gestión de energía entre el kernel de Linux y la implementación específica de NVIDIA. Al deshabilitarlos, se permite que la gestión de energía nativa del kernel se haga cargo, lo que podría ser más estable en este contexto de hardware/firmware.

**Acción:** Deshabilite estos servicios:

Bash

sudo systemctl stop nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service  
sudo systemctl disable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service  
\# Opcional: Eliminar el script de suspensión de systemd heredado si existe  
sudo rm \-f /lib/systemd/system-sleep/nvidia  
sudo reboot

Esta es una solución alternativa ampliamente reportada.3 Sin embargo, podría impedir que la GPU entre en sus estados de ahorro de energía más profundos durante la suspensión.61 Además, estos servicios pueden reactivarse después de las actualizaciones del controlador NVIDIA, lo que requiere volver a aplicar los comandos de deshabilitación.3

También se ha observado que los problemas de suspensión/reanudación pueden estar ligados a versiones específicas del controlador NVIDIA, con versiones más recientes que a veces introducen regresiones.3 Si la deshabilitación de los servicios no ayuda, se podría considerar la posibilidad de volver a una versión estable conocida del controlador NVIDIA para el kernel y la GPU, si está disponible en los repositorios de Debian o en los archivos de NVIDIA.

### **Parcheo de DSDT (Solución Avanzada)**

El parcheo de DSDT representa la intervención más profunda y directa para corregir fallos fundamentales del firmware que HP no está dispuesto o no puede abordar. Implica corregir la implementación de ACPI de la BIOS desde el lado del sistema operativo.

**Concepto:** Este proceso implica extraer las tablas ACPI (DSDT, SSDT) de la BIOS, desensamblarlas en ACPI Machine Language (AML), identificar y corregir manualmente los errores (por ejemplo, solucionar la lógica \_DOD vs \_DOS, resolver problemas de AE\_NOT\_FOUND), volver a compilar las tablas parcheadas y luego cargarlas al inicio para anular las tablas defectuosas de la BIOS.44

**Pasos (alto nivel):**

1. Extraer tablas ACPI: sudo acpidump \> acpi.dat (o desde /sys/firmware/acpi/tables).44  
2. Desensamblar: iasl \-d acpi.dat (requiere el compilador iasl).62  
3. Editar archivos .dsl: Identificar y corregir errores (por ejemplo, añadir métodos \_DOS, corregir referencias de símbolos). Esto requiere un conocimiento profundo de la especificación ACPI y AML.  
4. Compilar: iasl \-tc \<archivo\_parcheado\>.dsl.  
5. Cargar tablas parcheadas: Generalmente a través de GRUB o initramfs (por ejemplo, usando el parámetro del kernel acpi\_override o colocando archivos .aml en /boot/acpi).

**Riesgos y Beneficios:**

* **Alto Riesgo:** Un parcheo incorrecto puede provocar inestabilidad del sistema, fallos de arranque o incluso inutilizar la placa base.  
* **Alta Recompensa:** Puede solucionar de forma definitiva errores fundamentales de la BIOS que de otro modo no serían abordables por el proveedor.  
* **Complejidad:** Requiere conocimientos expertos de ACPI, lenguajes similares al ensamblador (AML) y procesos de arranque de Linux.

### **Soluciones Alternativas para Problemas Secundarios (Contingencia/Mitigación)**

Aunque el objetivo principal es resolver el problema de suspensión, es importante tener soluciones para los problemas secundarios mientras se trabaja en la causa raíz o si esta no se puede solucionar por completo.

* **Reactivación de Secure Boot:** La solución principal es prevenir los apagados forzados arreglando el problema de suspensión. Si Secure Boot se reactiva, la solución inmediata sigue siendo deshabilitarlo en la BIOS/UEFI.  
* **Perfiles de Navegador Corruptos:** La solución inmediata es eliminar los archivos de bloqueo del perfil: rm \-f /home/cesar/.config/microsoft-edge/Singleton\*. La solución a largo plazo depende de la corrección de la suspensión para permitir cierres de aplicaciones correctos.  
* **Pérdida de Salida HDMI:** Esto es una consecuencia directa del fallo del controlador NVIDIA. La restauración del controlador NVIDIA (resolviendo los problemas de Secure Boot y/o aplicando soluciones alternativas de suspensión/reanudación) debería restaurar la funcionalidad HDMI.  
* **Problemas de Wi-Fi/Bluetooth al Reanudar:** Algunos usuarios informan que el Wi-Fi/Bluetooth no funciona después de la reanudación, o incluso que impide una suspensión adecuada.1 Esto puede ser un problema de gestión de energía separado para estos dispositivos específicos. Más allá de los problemas generales de ACPI y GPU, los periféricos individuales como Wi-Fi y Bluetooth pueden tener sus propias peculiaridades de gestión de energía que interfieren con la suspensión/reanudación. Abordar esto requiere una gestión de controladores específica.  
  **Acción:** Revise journalctl en busca de errores relacionados con Wi-Fi (por ejemplo, mt7921 para MediaTek, común en algunos modelos HP) o Bluetooth alrededor de los tiempos de suspensión/reanudación. Una solución potencial es implementar *hooks* de suspensión de systemd para descargar los módulos de Wi-Fi/Bluetooth *antes* de la suspensión y recargarlos *después* de la reanudación.21 Esto puede mitigar los problemas del controlador durante las transiciones de estado de energía.  
  Ejemplo de script (/usr/lib/systemd/system-sleep/unload-mt7921.sh):  
  Bash  
  \#\!/bin/sh  
  case "$1" in  
    pre)  
      \# block networking to speed up unload  
      /usr/bin/rfkill block wifi  
      /usr/bin/rfkill block bluetooth  
      \# unload modules  
      /usr/sbin/modprobe \-r mt7921e \# Adjust module name as needed (e.g., btusb for Bluetooth)  
      ;;  
    post)  
      \# reload modules  
      /usr/sbin/modprobe mt7921e  
      /usr/bin/rfkill unblock wifi  
      /usr/bin/rfkill unblock bluetooth  
      ;;  
  esac

  Haga el script ejecutable: sudo chmod \+x /usr/lib/systemd/system-sleep/unload-mt7921.sh.

## **Recomendaciones y Próximos Pasos**

La resolución del persistente fallo de suspensión en el HP Victus con Debian 12 requiere un enfoque metódico y escalonado. Se recomienda seguir el siguiente plan de acción priorizado:

1. **Comenzar con Parámetros del Kernel:**  
   * Inicie las pruebas con acpi\_osi="Windows XXXX" y intel\_idle.max\_cstate=4 (o 1\) de forma individual. La identificación del valor XXXX para acpi\_osi debe realizarse consultando la DSDT del sistema. Estos parámetros son menos invasivos y han demostrado éxito en hardware similar. Una vez probados individualmente, considere combinarlos si es necesario.  
2. **Gestionar Servicios de NVIDIA:**  
   * Si los parámetros del kernel no resuelven completamente el problema, proceda a deshabilitar los servicios de gestión de energía de systemd de NVIDIA (nvidia-suspend.service, nvidia-hibernate.service, nvidia-resume.service). Reinicie el sistema después de aplicar los cambios.  
3. **Intentar Forzar mem\_sleep\_default=deep:**  
   * Verifique si el estado de suspensión deep está realmente disponible en el sistema (cat /sys/power/mem\_sleep). Si es así, intente forzarlo. Si esta acción falla o causa inestabilidad, revierta el cambio y enfoque los esfuerzos en optimizar el estado s2idle.  
4. **Abordar Problemas de Wi-Fi/Bluetooth (si son relevantes):**  
   * Si los registros (journalctl) indican problemas con los módulos de Wi-Fi o Bluetooth durante la reanudación, implemente los *hooks* de suspensión de systemd para descargar y recargar estos módulos.  
5. **Parcheo de DSDT (Último Recurso):**  
   * Esta solución solo debe considerarse si todas las soluciones alternativas a nivel del kernel y del controlador fallan. Requiere experiencia avanzada y el usuario debe ser plenamente consciente de los riesgos significativos que implica, incluyendo la posibilidad de inutilizar la placa base.

Monitorización y Verificación:  
Después de cada cambio, es crucial reiniciar el sistema y realizar pruebas exhaustivas de suspensión y reanudación. Se debe revisar meticulosamente sudo journalctl \-b \-1 | grep \-i "ACPI" (para el arranque anterior) y sudo journalctl \-b | grep \-i "ACPI" (para el arranque actual) para observar cualquier cambio en los mensajes de error de ACPI. Además, es fundamental monitorizar el comportamiento general del sistema en cuanto a estabilidad, consumo de energía (por ejemplo, con powertop) y la funcionalidad de todos los periféricos.  
Interacción con la Comunidad y el Proveedor:  
Si se encuentran soluciones o si el problema persiste a pesar de una depuración exhaustiva, se recomienda reportar un error detallado a las listas de correo o rastreadores de errores de ACPI o gestión de energía del kernel de Linux. Proporcionar registros completos y la información del sistema es vital. Aunque el soporte de HP para Linux ha sido históricamente limitado 2, informar formalmente el problema al soporte de HP (incluso a través de sus canales centrados en Windows) puede contribuir a futuras mejoras del firmware si un número suficiente de usuarios reporta problemas similares.  
Optimización de s2idle (Si deep es Inalcanzable):  
Si el estado de suspensión deep (S3) no puede lograrse de forma fiable debido a limitaciones del firmware, la estrategia debe cambiar a la optimización del estado s2idle para minimizar el consumo de batería.53 Esto implica adaptar el sistema operativo a las limitaciones del hardware. Se pueden utilizar herramientas como  
powertop para identificar y ajustar procesos o dispositivos que consumen mucha energía. También se recomienda ajustar los perfiles de energía (por ejemplo, la configuración de tlp) para maximizar el ahorro de energía en s2idle.

## **Conclusión**

El persistente fallo de reanudación de la suspensión en el HP Victus con Debian 12 se atribuye principalmente a errores profundamente arraigados en el firmware ACPI de la BIOS de HP. Estos fallos, en particular la ausencia del método \_DOS para la gestión de la pantalla y la falta general de cumplimiento de ACPI, impiden directamente que el kernel de Linux y los controladores NVIDIA manejen correctamente las transiciones de estado de energía. La falta de resolución de estos problemas mediante las actualizaciones de firmware del fabricante subraya una deficiencia en el soporte de HP para entornos Linux.

Aunque una "solución" definitiva podría requerir una actualización de BIOS conforme por parte de HP, varias estrategias avanzadas a nivel del kernel (incluyendo acpi\_osi, intel\_idle.max\_cstate y mem\_sleep\_default) y la gestión de los controladores NVIDIA ofrecen vías prometedoras para la mitigación. Si la suspensión deep completa sigue siendo inalcanzable, la optimización del estado s2idle se vuelve crucial para la usabilidad práctica. Este caso ilustra los desafíos continuos de lograr una compatibilidad total de hardware para Linux en portátiles de consumo, lo que a menudo exige una resolución de problemas sofisticada y de múltiples capas, así como la voluntad de interactuar con las complejidades del kernel y el firmware.

#### **Obras citadas**

1. Black screen after resume from sleep (intermittent issue) \- Ubuntu Discourse, fecha de acceso: julio 2, 2025, [https://discourse.ubuntu.com/t/black-screen-after-resume-from-sleep-intermittent-issue/61324](https://discourse.ubuntu.com/t/black-screen-after-resume-from-sleep-intermittent-issue/61324)  
2. acpi errors on boot & laptop doesnt wake from suspend : r/debian \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/debian/comments/18pwmpt/acpi\_errors\_on\_boot\_laptop\_doesnt\_wake\_from/](https://www.reddit.com/r/debian/comments/18pwmpt/acpi_errors_on_boot_laptop_doesnt_wake_from/)  
3. Tip for anyone having trouble with suspend/resume with NVIDIA: disable the NVIDIA systemd power management services, then reboot. \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/pop\_os/comments/1hp90yy/tip\_for\_anyone\_having\_trouble\_with\_suspendresume/](https://www.reddit.com/r/pop_os/comments/1hp90yy/tip_for_anyone_having_trouble_with_suspendresume/)  
4. 565.57.01 won't resume from "suspend to RAM" \- Linux \- NVIDIA Developer Forums, fecha de acceso: julio 2, 2025, [https://forums.developer.nvidia.com/t/565-57-01-wont-resume-from-suspend-to-ram/311956](https://forums.developer.nvidia.com/t/565-57-01-wont-resume-from-suspend-to-ram/311956)  
5. HP Victus 15-fa0xxx Linux Suspend Broken — Only s2idle Available, No Deep Sleep (S3)- cant put laptop into sleep mode \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/linuxquestions/comments/1krpywf/hp\_victus\_15fa0xxx\_linux\_suspend\_broken\_only/](https://www.reddit.com/r/linuxquestions/comments/1krpywf/hp_victus_15fa0xxx_linux_suspend_broken_only/)  
6. Suspend/Sleep Not Working Properly on HP Victus 15-fa0xxx with Linux \- HP Community, fecha de acceso: julio 2, 2025, [https://h30434.www3.hp.com/t5/Gaming-Notebooks/Suspend-Sleep-Not-Working-Properly-on-HP-Victus-15-fa0xxx/m-p/9398236](https://h30434.www3.hp.com/t5/Gaming-Notebooks/Suspend-Sleep-Not-Working-Properly-on-HP-Victus-15-fa0xxx/m-p/9398236)  
7. Suspend/Sleep Not Working Properly on HP Victus 15-fa0xxx wi... \- HP Support Community, fecha de acceso: julio 2, 2025, [https://h30434.www3.hp.com/t5/Gaming-Notebooks/Suspend-Sleep-Not-Working-Properly-on-HP-Victus-15-fa0xxx/td-p/9398236](https://h30434.www3.hp.com/t5/Gaming-Notebooks/Suspend-Sleep-Not-Working-Properly-on-HP-Victus-15-fa0xxx/td-p/9398236)  
8. Linux on the Victus. Distro were sleep works? : r/HPVictus \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/HPVictus/comments/1enbq94/linux\_on\_the\_victus\_distro\_were\_sleep\_works/](https://www.reddit.com/r/HPVictus/comments/1enbq94/linux_on_the_victus_distro_were_sleep_works/)  
9. \[SOLVED\] HP Victus 16 D1450nd system crashes after S2idle / Laptop Issues / Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=283541](https://bbs.archlinux.org/viewtopic.php?id=283541)  
10. Laptop appears to sleep but not suspend \- Fedora Discussion, fecha de acceso: julio 2, 2025, [https://discussion.fedoraproject.org/t/laptop-appears-to-sleep-but-not-suspend/77193](https://discussion.fedoraproject.org/t/laptop-appears-to-sleep-but-not-suspend/77193)  
11. P Victus 15-fa0xxx Linux Suspend Broken — Only s2idle Available, No Deep Sleep (S3)- cant put laptop into sleep mode : r/linux4noobs \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/linux4noobs/comments/1krq8xj/p\_victus\_15fa0xxx\_linux\_suspend\_broken\_only/](https://www.reddit.com/r/linux4noobs/comments/1krq8xj/p_victus_15fa0xxx_linux_suspend_broken_only/)  
12. Help Needed with HP Victus 16 E Dual Boot (Ubuntu 22.04 LTS) \- Sleep Mode Issue, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/techsupport/comments/1bslp09/help\_needed\_with\_hp\_victus\_16\_e\_dual\_boot\_ubuntu/](https://www.reddit.com/r/techsupport/comments/1bslp09/help_needed_with_hp_victus_16_e_dual_boot_ubuntu/)  
13. HP Victus AMD \- Unable to start from suspend on Ubuntu 22.04, fecha de acceso: julio 2, 2025, [https://askubuntu.com/questions/1445328/hp-victus-amd-unable-to-start-from-suspend-on-ubuntu-22-04/1445830](https://askubuntu.com/questions/1445328/hp-victus-amd-unable-to-start-from-suspend-on-ubuntu-22-04/1445830)  
14. Fixing Broken Suspend on HP Spectre 2022 \- General \- Universal Blue Discourse, fecha de acceso: julio 2, 2025, [https://universal-blue.discourse.group/t/fixing-broken-suspend-on-hp-spectre-2022/3326](https://universal-blue.discourse.group/t/fixing-broken-suspend-on-hp-spectre-2022/3326)  
15. RTX 4060 (Lenovo, Legion Pro 7i Gen 14): Black Screen on Suspend/Resume on OpenSUSE Tumbleweed after NVIDIA Driver Installation (Hybrid Method), fecha de acceso: julio 2, 2025, [https://forums.developer.nvidia.com/t/rtx-4060-lenovo-legion-pro-7i-gen-14-black-screen-on-suspend-resume-on-opensuse-tumbleweed-after-nvidia-driver-installation-hybrid-method/334946](https://forums.developer.nvidia.com/t/rtx-4060-lenovo-legion-pro-7i-gen-14-black-screen-on-suspend-resume-on-opensuse-tumbleweed-after-nvidia-driver-installation-hybrid-method/334946)  
16. Black screen (with mouse) when resuming suspend \- Nvidia / Applications & Desktop Environments / Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=295745](https://bbs.archlinux.org/viewtopic.php?id=295745)  
17. ubuntu does not go to sleep \- Linux.org, fecha de acceso: julio 2, 2025, [https://www.linux.org/threads/ubuntu-does-not-go-to-sleep.54960/](https://www.linux.org/threads/ubuntu-does-not-go-to-sleep.54960/)  
18. Issue: Unable to Suspend : r/archlinux \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/archlinux/comments/1ileuvw/issue\_unable\_to\_suspend/](https://www.reddit.com/r/archlinux/comments/1ileuvw/issue_unable_to_suspend/)  
19. HP Victus 16 (2023) having Black flickering screen, also bla... \- HP Support Community, fecha de acceso: julio 2, 2025, [https://h30434.www3.hp.com/t5/Notebook-Video-Display-and-Touch/HP-Victus-16-2023-having-Black-flickering-screen-also-black/td-p/9402233](https://h30434.www3.hp.com/t5/Notebook-Video-Display-and-Touch/HP-Victus-16-2023-having-Black-flickering-screen-also-black/td-p/9402233)  
20. Victus 16 black screen \- HP Support Community \- 9066984, fecha de acceso: julio 2, 2025, [https://h30434.www3.hp.com/t5/Gaming-Notebooks/Victus-16-black-screen/td-p/9066984](https://h30434.www3.hp.com/t5/Gaming-Notebooks/Victus-16-black-screen/td-p/9066984)  
21. Workaround for the suspension bug: HP Victus 15 with RTX 3050, Mediatek MT7921, Fedora 42, fecha de acceso: julio 2, 2025, [https://discussion.fedoraproject.org/t/workaround-for-the-suspension-bug-hp-victus-15-with-rtx-3050-mediatek-mt7921-fedora-42/151105](https://discussion.fedoraproject.org/t/workaround-for-the-suspension-bug-hp-victus-15-with-rtx-3050-mediatek-mt7921-fedora-42/151105)  
22. \[Solved\] System gets borked after suspending / Newbie Corner / Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=278820](https://bbs.archlinux.org/viewtopic.php?id=278820)  
23. Why does my computer not turn back on after I suspended it? \- Ubuntu Documentation, fecha de acceso: julio 2, 2025, [https://help.ubuntu.com/stable/ubuntu-help/power-suspendfail.html.tr](https://help.ubuntu.com/stable/ubuntu-help/power-suspendfail.html.tr)  
24. Ubuntu 22.04 does not resume after suspend, fecha de acceso: julio 2, 2025, [https://askubuntu.com/questions/1541427/ubuntu-22-04-does-not-resume-after-suspend](https://askubuntu.com/questions/1541427/ubuntu-22-04-does-not-resume-after-suspend)  
25. Need help with suspend / resume service \- archlinux \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/archlinux/comments/1hrxviv/need\_help\_with\_suspend\_resume\_service/](https://www.reddit.com/r/archlinux/comments/1hrxviv/need_help_with_suspend_resume_service/)  
26. \[SOLVED\] Can't resume from suspend \- Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=288250](https://bbs.archlinux.org/viewtopic.php?id=288250)  
27. Black screen after install of nvidia driver ubuntu for HP victus laptop, fecha de acceso: julio 2, 2025, [https://forums.developer.nvidia.com/t/black-screen-after-install-of-nvidia-driver-ubuntu-for-hp-victus-laptop/325443](https://forums.developer.nvidia.com/t/black-screen-after-install-of-nvidia-driver-ubuntu-for-hp-victus-laptop/325443)  
28. ACPI \_OSI and \_REV methods \- The Linux Kernel documentation, fecha de acceso: julio 2, 2025, [https://docs.kernel.org/firmware-guide/acpi/osi.html](https://docs.kernel.org/firmware-guide/acpi/osi.html)  
29. Display-specific Methods — ACPI Specification 6.4 documentation, fecha de acceso: julio 2, 2025, [https://uefi.org/htmlspecs/ACPI\_Spec\_6\_4\_html/Apx\_B\_Video\_Extensions/display-specific-methods.html](https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/Apx_B_Video_Extensions/display-specific-methods.html)  
30. Suspend/Resume \- FreeBSD Wiki, fecha de acceso: julio 2, 2025, [https://wiki.freebsd.org/SuspendResume](https://wiki.freebsd.org/SuspendResume)  
31. Suspend/Resume (Linux) \- Toradex Developer Center, fecha de acceso: julio 2, 2025, [https://developer.toradex.com/software/linux-resources/linux-features/suspendresume-linux/](https://developer.toradex.com/software/linux-resources/linux-features/suspendresume-linux/)  
32. Disabling the Intel Idle Driver \- Azul Docs, fecha de acceso: julio 2, 2025, [https://docs.azul.com/prime/zst/disabling-intel-idle-driver](https://docs.azul.com/prime/zst/disabling-intel-idle-driver)  
33. intel\_idle CPU Idle Time Management Driver \- The Linux Kernel Archives, fecha de acceso: julio 2, 2025, [https://www.kernel.org/doc/html/v5.8/admin-guide/pm/intel\_idle.html](https://www.kernel.org/doc/html/v5.8/admin-guide/pm/intel_idle.html)  
34. intel\_idle CPU Idle Time Management Driver \- The Linux Kernel documentation, fecha de acceso: julio 2, 2025, [https://docs.kernel.org/admin-guide/pm/intel\_idle.html](https://docs.kernel.org/admin-guide/pm/intel_idle.html)  
35. processor.max\_cstate, intel\_idle.max\_cstate and /dev/cpu\_dma\_latency, fecha de acceso: julio 2, 2025, [https://jeremyeder.com/2012/11/14/processor-max\_cstate-intel\_idle-max\_cstate-and-devcpu\_dma\_latency/](https://jeremyeder.com/2012/11/14/processor-max_cstate-intel_idle-max_cstate-and-devcpu_dma_latency/)  
36. System Sleep States \- The Linux Kernel documentation, fecha de acceso: julio 2, 2025, [https://docs.kernel.org/admin-guide/pm/sleep-states.html](https://docs.kernel.org/admin-guide/pm/sleep-states.html)  
37. ACPI BIOS Error Ubuntu AE Not Found | Resolved \- Bobcares, fecha de acceso: julio 2, 2025, [https://bobcares.com/blog/acpi-bios-error-ubuntu-ae-not-found/](https://bobcares.com/blog/acpi-bios-error-ubuntu-ae-not-found/)  
38. \[SOLVED\] ACPI BIOS Error after upgrading the kernel \- Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=303736](https://bbs.archlinux.org/viewtopic.php?id=303736)  
39. Wifi connected but not working, Bluetooth randomly crashing, Random black screen after suspend \- Manjaro Linux Forum, fecha de acceso: julio 2, 2025, [https://forum.manjaro.org/t/wifi-connected-but-not-working-bluetooth-randomly-crashing-random-black-screen-after-suspend/97038](https://forum.manjaro.org/t/wifi-connected-but-not-working-bluetooth-randomly-crashing-random-black-screen-after-suspend/97038)  
40. Hybrid graphics \- ArchWiki, fecha de acceso: julio 2, 2025, [https://wiki.archlinux.org/title/Hybrid\_graphics](https://wiki.archlinux.org/title/Hybrid_graphics)  
41. Suspend not working properly (cannot wake up) on Ubuntu 20.04 with NVIDIA \[duplicate\], fecha de acceso: julio 2, 2025, [https://askubuntu.com/questions/1345073/suspend-not-working-properly-cannot-wake-up-on-ubuntu-20-04-with-nvidia](https://askubuntu.com/questions/1345073/suspend-not-working-properly-cannot-wake-up-on-ubuntu-20-04-with-nvidia)  
42. Victus by HP 16.1 inch Gaming Laptop PC 16-e0000 Software and Driver Downloads, fecha de acceso: julio 2, 2025, [https://support.hp.com/us-en/drivers/victus-by-hp-16.1-inch-gaming-laptop-pc-16-e0000/2100371512](https://support.hp.com/us-en/drivers/victus-by-hp-16.1-inch-gaming-laptop-pc-16-e0000/2100371512)  
43. Maintenance and Service Guide Victus by HP 16.1 inch Gaming Laptop PCModel numbers: 16-s0xxx, fecha de acceso: julio 2, 2025, [https://kaas.hpcloud.hp.com/pdf-public/pdf\_7911438\_en-US-1.pdf](https://kaas.hpcloud.hp.com/pdf-public/pdf_7911438_en-US-1.pdf)  
44. ACPI Error AE\_NOT\_FOUND GPE.PL6B \- Support and Help ..., fecha de acceso: julio 2, 2025, [https://discourse.ubuntu.com/t/acpi-error-ae-not-found-gpe-pl6b/53354](https://discourse.ubuntu.com/t/acpi-error-ae-not-found-gpe-pl6b/53354)  
45. \[RESPONDED\] About acpi\_osi kernel parameter \- Linux \- Framework Community, fecha de acceso: julio 2, 2025, [https://community.frame.work/t/responded-about-acpi-osi-kernel-parameter/27092](https://community.frame.work/t/responded-about-acpi-osi-kernel-parameter/27092)  
46. kernel parameters documentation, fecha de acceso: julio 2, 2025, [https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt](https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt)  
47. DSDT \- ArchWiki \- Arch Linux, fecha de acceso: julio 2, 2025, [https://wiki.archlinux.org/title/DSDT](https://wiki.archlinux.org/title/DSDT)  
48. Kernel parameters \- ArchWiki, fecha de acceso: julio 2, 2025, [https://wiki.archlinux.org/title/Kernel\_parameters](https://wiki.archlinux.org/title/Kernel_parameters)  
49. How do I add a kernel boot parameter? \- Ask Ubuntu, fecha de acceso: julio 2, 2025, [https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter](https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter)  
50. linux kernel \- How to set intel\_idle.max\_cstate=0 to disable c-states? \- Stack Overflow, fecha de acceso: julio 2, 2025, [https://stackoverflow.com/questions/22482252/how-to-set-intel-idle-max-cstate-0-to-disable-c-states](https://stackoverflow.com/questions/22482252/how-to-set-intel-idle-max-cstate-0-to-disable-c-states)  
51. \[SOLVED\] Sleep/hibernation not working on HP Victus 15 Laptop \- Arch Linux Forums, fecha de acceso: julio 2, 2025, [https://bbs.archlinux.org/viewtopic.php?id=299251](https://bbs.archlinux.org/viewtopic.php?id=299251)  
52. How to set intel\_idle.max\_cstate=1 \- Ask Ubuntu, fecha de acceso: julio 2, 2025, [https://askubuntu.com/questions/749349/how-to-set-intel-idle-max-cstate-1](https://askubuntu.com/questions/749349/how-to-set-intel-idle-max-cstate-1)  
53. \[RESPONDED\] Linux s2idle sleep "random" power usage increase \- Framework Community, fecha de acceso: julio 2, 2025, [https://community.frame.work/t/responded-linux-s2idle-sleep-random-power-usage-increase/26905](https://community.frame.work/t/responded-linux-s2idle-sleep-random-power-usage-increase/26905)  
54. s2idle \- double power usage after resume : r/linuxquestions \- Reddit, fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/linuxquestions/comments/1bidylq/s2idle\_double\_power\_usage\_after\_resume/](https://www.reddit.com/r/linuxquestions/comments/1bidylq/s2idle_double_power_usage_after_resume/)  
55. In use battery life is largely the same, though Intel has added some additional, fecha de acceso: julio 2, 2025, [https://news.ycombinator.com/item?id=31433666](https://news.ycombinator.com/item?id=31433666)  
56. How to check if power management is configured in Linux \- LabEx, fecha de acceso: julio 2, 2025, [https://labex.io/tutorials/linux-how-to-check-if-power-management-is-configured-in-linux-558801](https://labex.io/tutorials/linux-how-to-check-if-power-management-is-configured-in-linux-558801)  
57. Power management/Suspend and hibernate \- ArchWiki \- Arch Linux, fecha de acceso: julio 2, 2025, [https://wiki.archlinux.org/title/Power\_management/Suspend\_and\_hibernate](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate)  
58. Hi, I have a serious problem when I try to start the computer. | Linux.org, fecha de acceso: julio 2, 2025, [https://www.linux.org/threads/hi-i-have-a-serious-problem-when-i-try-to-start-the-computer.48699/](https://www.linux.org/threads/hi-i-have-a-serious-problem-when-i-try-to-start-the-computer.48699/)  
59. Persistent ACPI/\_DSM, GPU Power, and Freezing Issues \- Linux.org, fecha de acceso: julio 2, 2025, [https://www.linux.org/threads/persistent-acpi-\_dsm-gpu-power-and-freezing-issues.55289/](https://www.linux.org/threads/persistent-acpi-_dsm-gpu-power-and-freezing-issues.55289/)  
60. NVIDIA 470.82 locks up on suspend \- Linux, fecha de acceso: julio 2, 2025, [https://forums.developer.nvidia.com/t/nvidia-470-82-locks-up-on-suspend/194757](https://forums.developer.nvidia.com/t/nvidia-470-82-locks-up-on-suspend/194757)  
61. Nvidia Arch Linux minimal setup \- Savely Krasovsky's blog, fecha de acceso: julio 2, 2025, [https://krasovs.ky/2024/10/31/nvidia-arch-linux-minimal-setup.html](https://krasovs.ky/2024/10/31/nvidia-arch-linux-minimal-setup.html)  
62. dsdt \- GitHub Gist, fecha de acceso: julio 2, 2025, [https://gist.github.com/robsnider/52eb6711ef59352cccfc766b25e00480](https://gist.github.com/robsnider/52eb6711ef59352cccfc766b25e00480)  
63. HP Victus 15/16 \- How to extend Battery life and its longevity TIPS compendium (possibly for Pavilion Gaming and OMEN too), fecha de acceso: julio 2, 2025, [https://www.reddit.com/r/GamingLaptops/comments/109h8kl/hp\_victus\_1516\_how\_to\_extend\_battery\_life\_and\_its/](https://www.reddit.com/r/GamingLaptops/comments/109h8kl/hp_victus_1516_how_to_extend_battery_life_and_its/)  
64. My HP victus 16 battery draining fast \- HP Support Community \- 9134272, fecha de acceso: julio 2, 2025, [https://h30434.www3.hp.com/t5/Notebook-Software-and-How-To-Questions/My-HP-victus-16-battery-draining-fast/td-p/9134272](https://h30434.www3.hp.com/t5/Notebook-Software-and-How-To-Questions/My-HP-victus-16-battery-draining-fast/td-p/9134272)