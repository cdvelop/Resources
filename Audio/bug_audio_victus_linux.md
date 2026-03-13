# Bug: Micrófono externo mezclado con interno en HP Victus - Debian 12

## Equipo
- **Laptop**: HP Victus 16-d0xxx
- **OS**: Debian 12 (Linux 6.1.0-44-amd64)
- **Audio driver**: sof-hda-dsp (Tiger Lake-H HD Audio Controller)
- **Audio server**: PipeWire 0.3.65 + WirePlumber

## Problema

Al conectar un micrófono externo al jack combo (entrada dual headset) de la laptop, OBS captura audio del micrófono interno (DMIC) o mezcla ambas entradas. Aunque se seleccione el micrófono externo, al apagarlo el interno sigue captando señal.

## Diagnóstico

### 1. Listar fuentes de audio

```bash
wpctl status
```

Resultado relevante:

```
Sources:
    50. Tiger Lake-H HD Audio Controller Headphones Stereo Microphone [vol: 1.00]
 *  51. Tiger Lake-H HD Audio Controller Digital Microphone [vol: 0.28]
```

- **Source 50** (`HDA Analog`, `hw:sofhdadsp`) = micrófono externo vía jack combo
- **Source 51** (`DMIC`, `hw:sofhdadsp,6`) = micrófono digital interno (predeterminado `*`)

### 2. Verificar detalles de cada fuente

```bash
wpctl inspect 50   # HDA Analog - jack combo (externo)
wpctl inspect 51   # DMIC - micrófono digital interno
```

### 3. Listar fuentes con PulseAudio (alternativa)

```bash
pactl list sources short
```

```
50  alsa_input...HiFi__hw_sofhdadsp__source     # Headphones Stereo Microphone (externo)
51  alsa_input...HiFi__hw_sofhdadsp_6__source   # Digital Microphone (interno)
```

## Causa raíz

El driver `sof-hda-dsp` en HP Victus no desactiva automáticamente el micrófono interno (DMIC) cuando se conecta un micrófono externo al jack combo. La detección de jack no distingue correctamente entre headset (auriculares + mic) y headphones (solo auriculares). Esto provoca que:

1. El DMIC interno quede como fuente **predeterminada** del sistema.
2. OBS (y otras apps) usen "Default" que apunta al DMIC.
3. Aunque se seleccione el externo, el interno sigue activo y puede mezclarse.

## Solución

### Paso 1: Seleccionar el micrófono externo como predeterminado

```bash
wpctl set-default 50
```

> **Nota**: El ID (50) puede cambiar entre reinicios. Para obtener el ID actual:
> ```bash
> wpctl status | grep -i "microphone\|mic"
> ```

### Paso 2: Silenciar el micrófono interno

```bash
wpctl set-mute 51 1
```

Para verificar que quedó silenciado:

```bash
wpctl get-volume 51
# Debe mostrar: Volume: 0.28 [MUTED]
```

### Paso 3: Mute a nivel ALSA (hardware)

El mute de pavucontrol/wpctl es **solo software** y puede dejar pasar ruido residual.
Para cortar la señal realmente, se necesita `alsa-utils`:

```bash
sudo apt install -y alsa-utils
```

Listar controles del micrófono interno:

```bash
amixer -c 1 scontents | grep -A3 -i "dmic"
```

Silenciar ambos DMIC a nivel hardware:

```bash
amixer -c 1 set 'Dmic0' nocap        # desactivar captura
amixer -c 1 set 'Dmic0' 0%           # volumen a 0
amixer -c 1 set 'Dmic1 2nd' 0%       # segundo DMIC a 0
```

Para restaurar si se necesita el mic interno:

```bash
amixer -c 1 set 'Dmic0' cap
amixer -c 1 set 'Dmic0' 51%
amixer -c 1 set 'Dmic1 2nd' 71%
```

### Paso 4: Configurar OBS

En OBS, la fuente de captura de audio **NO debe usar "Default"**. Seleccionar manualmente:

- **Headphones Stereo Microphone** (el HDA Analog, source 50)

### Paso 5: Noise Gate en OBS (ruido residual del jack)

Cuando el jack combo tiene algo conectado físicamente, el circuito analógico genera una
pequeña señal de entrada (ruido de piso) incluso con el micrófono externo apagado.
Esto es comportamiento normal del hardware — no es el DMIC interno.

Para eliminarlo, aplicar un **Noise Gate** en OBS:

1. Click derecho en la fuente de micrófono → **Filtros**
2. Agregar → **Noise Gate** (Puerta de ruido)
3. Configurar:
   - **Close Threshold**: -40 dB (corta señal por debajo de este nivel)
   - **Open Threshold**: -30 dB (abre cuando la señal supera este nivel)
   - Ajustar según el nivel de ruido propio del entorno

> **Nota**: Si al desconectar el jack no hay señal y al conectarlo (mic apagado) hay señal
> pequeña, es ruido de piso del circuito analógico — el noise gate lo elimina completamente.

### Paso 6: Hacer persistente (opcional)

Para que los cambios sobrevivan reinicios, crear un script en autostart o usar WirePlumber rules.

**Opción A - Script en autostart:**

Crear `~/.config/autostart/fix-mic.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Fix Microphone
Exec=bash -c "sleep 3 && wpctl set-default $(wpctl status | grep -B1 'Headphones Stereo Microphone' | head -1 | awk '{print $1}' | tr -d '.') && wpctl set-mute $(wpctl status | grep -B1 'Digital Microphone' | head -1 | awk '{print $1}' | tr -d '.') 1"
Hidden=false
NoDisplay=true
```

**Opción B - Regla de WirePlumber:**

Crear `~/.config/wireplumber/main.lua.d/51-disable-dmic.lua`:

```lua
rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_6__source" },
    },
  },
  apply_properties = {
    ["node.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules, rule)
```

> **Nota**: La opción B desactiva el DMIC completamente. Si necesitas usarlo sin el mic externo, usa la opción A.

## Comandos útiles de referencia

```bash
# Ver estado completo de audio
wpctl status

# Cambiar fuente predeterminada
wpctl set-default <ID>

# Silenciar/desilenciar fuente
wpctl set-mute <ID> 1    # mute
wpctl set-mute <ID> 0    # unmute

# Ver volumen y estado de mute
wpctl get-volume <ID>

# Inspeccionar detalles de un nodo
wpctl inspect <ID>

# Listar fuentes (formato corto)
pactl list sources short
```
