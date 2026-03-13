# Guía para verificar la frecuencia de muestreo en Debian 12

Debian 12 utiliza **PipeWire** por defecto para la gestión de audio. Aquí tienes cómo verificar la frecuencia de muestreo (sampling rate) de tus dispositivos y aplicaciones.

## 1. Verificación rápida en tiempo real (`pw-top`)

La forma más sencilla de ver qué frecuencia se está usando actualmente es con el comando `pw-top`.

```bash
pw-top
```

- **Qué buscar**: En la columna **RATE**, verás la frecuencia de cada flujo (stream) activo (ej. 44100, 48000).
- **Entradas**: Busca los nodos bajo la categoría de entrada (Input/Capture) para ver tu micrófono.

## 2. Listar dispositivos y sus IDs (`wpctl`)

Para identificar cuál es tu micrófono, usa:

```bash
wpctl status
```

Busca la sección **Sources**. El número a la izquierda (ej. `50`) es el ID del dispositivo.

## 3. Inspección detallada de un dispositivo (`pw-dump`)

Si quieres ver la configuración técnica profunda de un micrófono específico (ej. ID 50):

```bash
pw-dump 50 | grep -A 5 "format"
```

Esto mostrará el formato de audio y la tasa de muestreo (`rate`) que el dispositivo está usando o soporta.

## 4. Verificación a nivel de Hardware (ALSA)

Para estar 100% seguro de lo que el hardware está procesando en este momento (solo si el micrófono está en uso):

```bash
cat /proc/asound/card*/pcm*c/sub*/hw_params
```

- Si el archivo dice `closed`, el micrófono no está siendo usado por ninguna aplicación.
- Si está activo, verás algo como `rate: 48000 (48000/1)`.

## Resumen técnico en tu sistema:
- **Servidor**: PipeWire.
- **Tasa por defecto**: 48,000 Hz (48 kHz).
- **Herramienta recomendada**: `pw-top` para ver cambios en tiempo real.

---

# Comparativa: 44.1 kHz vs 48 kHz

Es común tener la duda de qué frecuencia es "mejor" o cuál deberías usar. Aquí tienes la respuesta a tus preguntas:

### 1. ¿Cuál es mejor?
- **48 kHz**: Es el estándar profesional para video, cine y televisión. Ofrece un rango dinámico ligeramente superior y es la frecuencia "nativa" de la mayoría de tarjetas de sonido integradas en PCs modernos.
- **44.1 kHz**: Es el estándar del CD de audio. Se usa principalmente en la industria musical.

**Veredicto**: Para uso general y gaming, **48 kHz es mejor** porque evita conversiones innecesarias de hardware.

### 2. ¿Por qué tienes 48? ¿Es por el hardware?
Sí. Tu tarjeta (**Tiger Lake-H HD Audio**) está diseñada para trabajar internamente a 48 kHz. PipeWire detecta esto y se ajusta automáticamente para ofrecer la mejor compatibilidad y menor latencia posible.

### 3. ¿Cuál consume menos recursos?
- **Teóricamente**: 44.1 kHz consume ~10% menos CPU porque procesa menos muestras por segundo.
- **En la práctica**: Si tu hardware es nativo de 48 kHz (como el tuyo) y tú configuras el sistema a 44.1 kHz, PipeWire tiene que hacer un proceso llamado **resampling** (remuestreo) para convertir 44.1 a 48. **Esto consume MUCHA más CPU** que simplemente dejarlo en 48.
- **Conclusión**: En tu hardware actual, **48 kHz consume menos recursos**.

### 4. ¿Cómo se puede cambiar?
Si aún así deseas forzar 44.1 kHz (por ejemplo, para producción musical específica), sigue estos pasos:

1. Crea el directorio de configuración si no existe:
   ```bash
   mkdir -p ~/.config/pipewire/
   ```

2. Copia la configuración por defecto:
   ```bash
   cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
   ```

3. Edita el archivo `~/.config/pipewire/pipewire.conf`:
   Busca la sección `context.properties` y añade o descomenta estas líneas:
   ```lua
   default.clock.rate          = 44100
   default.clock.allowed-rates = [ 44100 48000 ]
   ```

4. Reinicia PipeWire:
   ```bash
   systemctl --user restart pipewire
   ```
