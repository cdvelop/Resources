En Visual Studio Code puedes agregar una opción al menú contextual para ejecutar comandos seleccionados, esto puedes lograrlo utilizando la extensión `Code Runner`.


### tutorial 
https://www.youtube.com/watch?v=rQ6JQxMio2Q

### Opción 1: Usar la Extensión `Code Runner`

1. **Instalar la Extensión**:
   - Abre Visual Studio Code.
   - Ve a la pestaña de Extensiones (o presiona `Ctrl + Shift + X`).
   - Busca `Code Runner` y haz clic en "Instalar".

2. **Configurar la Extensión**:
   - Una vez instalada, esta extensión permite ejecutar el código seleccionado en la terminal.
   - Para ejecutar el código seleccionado, simplemente selecciona el código que quieres ejecutar, haz clic derecho y elige "Run Code" o presiona el atajo de teclado `Ctrl + Alt + N`.

   Por defecto, esto ejecutará el código en la terminal integrada de Visual Studio Code.

3. **Configuración Adicional**:
   - Si necesitas personalizar la configuración, puedes hacerlo en el archivo de configuración de usuario o proyecto (`settings.json`):
   ```json
   "code-runner.executorMap": {
       "javascript": "node",
       "python": "python",
       "bash": "bash"
       // Agrega aquí otros lenguajes o comandos que desees
   },
   "code-runner.runInTerminal": true,  // Para ejecutar en la terminal integrada
   "code-runner.clearPreviousOutput": true  // Para limpiar la terminal antes de cada ejecución
   ```

   ### recomendación antes de ejecutar código configura la opción guardar automáticamente
   "code-runner.saveAllFilesBeforeRun": true

   ### code runner por defecto ejecuta el codigo en output pero si quieres ejecutar en terminal
   "code-runner.runInTerminal": true