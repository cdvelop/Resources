quiero que el audio tenga una taza de muestra de 48000 Hz, mpeg aac mp4a,bit por muestra 32. el mkv tiene Emission 1 Idioma español, Emission 2 idioma ingles ambos con codec aka ac3 no es compatible con televisores antiguos

Para realizar la conversión del audio con las especificaciones que mencionas, utilizando **FFmpeg**, puedes ajustar el comando para que:

1. Cambie el códec de audio a AAC (MPEG-4 AAC LC, también conocido como `mp4a`).
2. Ajuste la tasa de muestreo a 48,000 Hz.
3. Configure el bit por muestra a 32 bits.

### Comando de FFmpeg

Aquí está el comando que puedes usar:

```bash
ffmpeg -i input.mkv -map 0 -c:v copy -c:a aac -ar 48000 -sample_fmt s32 -b:a 192k -metadata:s:a:0 language=spa -metadata:s:a:1 language=eng output.mkv
```

### Explicación del comando:

- `-i input.mkv`: Especifica el archivo de entrada.
- `-map 0`: Mapea todas las pistas (audio, video, subtítulos) desde el archivo de entrada al archivo de salida.
- `-c:v copy`: Copia el stream de video sin re-codificarlo.
- `-c:a aac`: Cambia el códec de audio a AAC.
- `-ar 48000`: Ajusta la tasa de muestreo de audio a 48,000 Hz.
- `-sample_fmt s32`: Configura el formato de muestra de audio a 32 bits por muestra.
- `-b:a 192k`: Establece la tasa de bits de audio a 192 kbps (puedes ajustarla si lo deseas).
- `-metadata:s:a:0 language=spa`: Establece el idioma del primer flujo de audio (Emisión 1) a español.
- `-metadata:s:a:1 language=eng`: Establece el idioma del segundo flujo de audio (Emisión 2) a inglés.
- `output.mkv`: Nombre del archivo de salida.

### Detalles adicionales:

- **Tasa de bits de audio (`-b:a`)**: Puedes ajustar este valor según la calidad que desees. 192 kbps es una buena opción para AAC, pero podrías usar 128k si prefieres un archivo más pequeño, o 256k para mayor calidad.
  
- **Idioma de las pistas de audio**: El comando asume que la primera pista es en español y la segunda en inglés. Si están en otro orden, puedes ajustar los índices (`:0` y `:1`).

Este comando mantendrá el video tal como está y convertirá ambas pistas de audio al formato y configuraciones que especificaste, asegurando compatibilidad con tu televisor.