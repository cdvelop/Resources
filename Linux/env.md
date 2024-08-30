En Linux, las variables de entorno se manejan usando comandos en el shell Bash. Aquí te explico cómo puedes trabajar con ellas:

### 1. **Ver las Variables de Entorno Actuales**
   Para ver las variables de entorno actuales, puedes usar el comando:
   ```bash
   printenv
   ```
   O también puedes usar:
   ```bash
   env
   ```
   Estos comandos listan todas las variables de entorno y sus valores.

### 2. **Definir una Variable de Entorno**
   Para definir una variable de entorno temporalmente (solo para la sesión actual), puedes usar el siguiente comando:
   ```bash
   export NOMBRE_VARIABLE="valor"
   ```
   Ejemplo:
   ```bash
   export MI_VARIABLE="Hola Mundo"
   ```

### 3. **Acceder al Valor de una Variable de Entorno**
   Puedes acceder al valor de una variable de entorno usando `$` seguido del nombre de la variable:
   ```bash
   echo $MI_VARIABLE
   ```

### 4. **Modificar una Variable de Entorno**
   Simplemente vuelve a usar el comando `export` con el nuevo valor:
   ```bash
   export MI_VARIABLE="Nuevo Valor"
   ```

### 5. **Eliminar una Variable de Entorno**
   Para eliminar una variable de entorno, puedes usar el comando `unset`:
   ```bash
   unset MI_VARIABLE
   ```

### 6. **Variables de Entorno Permanentes**
   Si deseas que una variable de entorno sea permanente, debes añadirla al archivo de configuración del shell. Por ejemplo, para Bash, puedes editar el archivo `~/.bashrc` o `~/.bash_profile` y añadir la línea:
   ```bash
   export MI_VARIABLE="valor"
   ```
   Luego, para aplicar los cambios, puedes ejecutar:
   ```bash
   source ~/.bashrc
   ```

### 7. **Usar Variables de Entorno Temporalmente en un Comando**
   Puedes usar una variable de entorno solo para la ejecución de un comando específico sin afectar el entorno general:
   ```bash
   NOMBRE_VARIABLE="valor" comando
   ```
   Ejemplo:
   ```bash
   MI_VARIABLE="Valor Temporal" echo $MI_VARIABLE
   ```

