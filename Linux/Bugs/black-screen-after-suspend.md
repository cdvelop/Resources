# Pantalla negra después de la suspensión en HP Victus con Debian 12

## Descripción del Problema

Al volver del estado de suspensión, la pantalla del portátil se queda en negro y no se recupera, lo que obliga a forzar el apagado del equipo manteniendo presionado el botón de encendido.

## Entorno del Sistema

| Característica | Valor                                       |
| :--------------- | :------------------------------------------ |
| **Usuario**      | `cesar@cs-laptop`                           |
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

## Síntomas

1.  La pantalla se queda en negro y no responde al volver de la suspensión.
2.  Es necesario forzar el apagado del equipo.
3.  Después de reiniciar, los navegadores Edge o Chromium (si estaban abiertos) no se pueden volver a abrir, lo que sugiere una posible corrupción del perfil.
4.  La salida de video a través de HDMI deja de funcionar; el monitor externo no recibe señal.
5.  Aparecen mensajes de error en color rojo durante el arranque después del apagado forzado, pero desaparecen demasiado rápido para leerlos.

## Pasos de Diagnóstico

### 1. Revisión de los Registros del Sistema

Se utilizaron los siguientes comandos para revisar los registros del sistema:

```bash
sudo journalctl -b -1 -p 3
```

Los resultados mostraron errores críticos relacionados con la carga de los módulos del kernel de NVIDIA:

```
May 29 13:04:03 cs-laptop systemd-modules-load[407]: Error running install command 'modprobe nvidia-modes>
May 29 13:04:03 cs-laptop systemd-modules-load[407]: Failed to insert module 'nvidia_drm': Invalid argume>
May 29 13:04:03 cs-laptop systemd[1]: Failed to start systemd-modules-load.service - Load Kernel Modules.
Jul 02 11:07:44 cs-laptop nvidia-persistenced[810]: Failed to query NVIDIA devices. Please ensure that th>
Jul 02 11:07:44 cs-laptop systemd[1]: Failed to start nvidia-persistenced.service - NVIDIA Persistence Da>
```

También se encontraron numerosos errores de ACPI, que pueden estar relacionados con la gestión de energía del sistema.

### 2. Verificación de los Módulos del Kernel de NVIDIA

Se ejecutó el siguiente comando para verificar si los módulos de NVIDIA estaban cargados:

```bash
lsmod | grep nvidia
```

El comando no devolvió ninguna salida, lo que confirma que los módulos del kernel de NVIDIA no se están cargando en el sistema.

### 3. Verificación de los Paquetes de NVIDIA Instalados

Se utilizó el siguiente comando para listar los paquetes de NVIDIA instalados:

```bash
dpkg -l | grep nvidia
```

La salida confirmó que los controladores de NVIDIA y las librerías asociadas están instaladas en el sistema.

## Conclusión del Diagnóstico

El problema principal es que los módulos del kernel de NVIDIA no se están cargando correctamente durante el arranque del sistema. Esto provoca que el sistema operativo no pueda gestionar correctamente la GPU de NVIDIA, lo que resulta en la pantalla negra después de la suspensión y la falta de señal en la salida HDMI.

## Pasos para la Solución

A continuación se intentarán los siguientes pasos para solucionar el problema:

### 1. Reinstalación de los Controladores de NVIDIA

Se reinstalarán los controladores de NVIDIA para asegurar que los módulos del kernel se construyan e instalen correctamente.

**a. Purgar los controladores existentes:**

```bash
sudo apt-get purge 'nvidia-*';
sudo apt-get autoremove;
```

**b. Instalar los controladores de NVIDIA:**

```bash
sudo apt-get install nvidia-driver firmware-nvidia-gsp
```

**c. Reiniciar el sistema:**

Después de la instalación, es necesario reiniciar el sistema para que los nuevos módulos del kernel se carguen.

```bash
sudo reboot
```
