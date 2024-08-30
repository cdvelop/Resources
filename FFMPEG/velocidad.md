Para asignar más recursos al proceso de FFmpeg en Windows y aprovechar mejor la CPU, puedes intentar algunas de las siguientes opciones:

### 1. **Prioridad del proceso en el Administrador de Tareas:**
   - Abre el **Administrador de Tareas** (Ctrl + Shift + Esc).
   - Busca el proceso de FFmpeg (normalmente aparece como `ffmpeg.exe`).
   - Haz clic derecho sobre él, selecciona **Ir a detalles**.
   - Una vez en la pestaña de **Detalles**, haz clic derecho sobre el proceso y selecciona **Establecer prioridad**.
   - Cambia la prioridad a **Alta** o **Tiempo real** (Ten cuidado con la opción de **Tiempo real**, ya que puede hacer que otros procesos en tu sistema se vuelvan lentos).

### 2. **Uso de múltiples núcleos con la opción `-threads`:**
   FFmpeg, por defecto, intenta utilizar todos los núcleos de la CPU, pero en algunos casos, es posible que no lo haga de manera eficiente. Puedes forzar a FFmpeg a usar más hilos (threads) con el parámetro `-threads`.

   ```bash
   ffmpeg -threads 8 -i input.mkv -map 0 -c:v copy -c:a aac -ar 48000 -b:a 192k -metadata:s:a:0 language=spa -metadata:s:a:1 language=eng output.mkv
   ```

   Reemplaza `8` con el número de hilos que deseas utilizar. Si tienes un procesador con más núcleos, como 8 o 16, puedes asignar más hilos para acelerar el proceso.

### 3. **Cerrar aplicaciones innecesarias:**
   Asegúrate de cerrar todas las aplicaciones que no estés utilizando. Esto liberará más recursos para FFmpeg.

### 4. **Aceleración de hardware (si tu GPU lo soporta):**
   FFmpeg también soporta la aceleración de hardware para ciertas tareas (principalmente para la codificación de video). Si tienes una GPU compatible (como Nvidia con CUDA o NVENC), puedes habilitar la aceleración de hardware.

   Aquí tienes un ejemplo de cómo habilitar NVENC (si estás usando una GPU Nvidia):

   ```bash
   ffmpeg -hwaccel nvdec -i input.mkv -map 0 -c:v h264_nvenc -c:a aac -ar 48000 -b:a 192k -metadata:s:a:0 language=spa -metadata:s:a:1 language=eng output.mkv
   ```

   Esto delegará parte del procesamiento a la GPU, lo que puede acelerar el proceso.

### 5. **Limitar procesos en segundo plano:**
   Asegúrate de que no haya otros procesos intensivos en segundo plano que puedan estar utilizando recursos de la CPU. También, desactiva temporalmente el antivirus si es seguro hacerlo, ya que a veces los antivirus pueden ralentizar los procesos intensivos como FFmpeg.

Al aplicar estas optimizaciones, deberías notar un uso más eficiente de tu CPU y una reducción en el tiempo de procesamiento.