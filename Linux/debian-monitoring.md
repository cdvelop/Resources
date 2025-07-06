La herramienta más completa en consola para monitorear GPU NVIDIA, CPU, RAM, disco y swap en tiempo real es **btop** (o su versión anterior, bpytop/bashtop). Sin embargo, para monitoreo específico de GPU NVIDIA, puedes complementar con **nvtop**.

### Resumen de herramientas:

- **btop**: Monitorea CPU, RAM, swap, disco, red y (en muchos sistemas) GPU NVIDIA (requiere soporte NVML). Es muy visual y fácil de usar.
- **nvtop**: Específico para GPU NVIDIA, muestra uso de VRAM, temperatura, procesos, etc.
- **Psensor**: Gráfico, muestra temperaturas de CPU, GPU y discos, pero no uso de RAM/CPU en detalle.
- **GNOME System Monitor**: Gráfico, monitorea CPU, RAM, disco, red, pero no GPU NVIDIA.

### Recomendación:
- Instala **btop** para monitoreo general (CPU, RAM, swap, disco, red y, si tu sistema lo soporta, GPU NVIDIA).
- Instala **nvtop** para monitoreo detallado de GPU NVIDIA.

#### Instalación:
```bash
sudo apt install btop nvtop
```

Luego ejecuta:
- `btop` para monitoreo general.
- `nvtop` para monitoreo de GPU NVIDIA.

cuendo arranco nvtop me entrega este mensaje:
This version of Nvtop is missing support for reporting Intel GPU memory, power,
fan and temperature

                            <Don't Show Again> <Ok>
         Press Enter to select, arrows ">" and "<" to switch options
Ese mensaje de nvtop es normal si tienes una GPU NVIDIA y no una Intel. Nvtop soporta múltiples tipos de GPU (NVIDIA, AMD, Intel), pero solo muestra información completa (memoria, temperatura, etc.) para la marca de GPU que detecta y para la que fue compilado con soporte.

En tu caso:
- Tienes una GPU NVIDIA, así que nvtop mostrará correctamente el uso de GPU, VRAM, procesos, temperatura, etc. para NVIDIA.
- El mensaje solo indica que si tuvieras una GPU Intel, no podrías ver esos datos (lo cual no te afecta).

Puedes presionar Enter en <Ok> y seguir usando nvtop normalmente. Si quieres que no vuelva a aparecer, selecciona <Don't Show Again>.

