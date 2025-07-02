Para habilitar el acceso SSH con contraseña para el usuario `root` en Debian, sigue estos pasos:

### 1. **Editar el Archivo de Configuración de SSH:**
   - Abre el archivo de configuración de SSH en el servidor:
     ```bash
     sudo nano /etc/ssh/sshd_config
     ```
   - Busca la línea que dice `PermitRootLogin` y cámbiala a `yes`:
     ```bash
     PermitRootLogin yes
     ```
   - Asegúrate de que la línea `PasswordAuthentication` esté configurada como `yes`:
     ```bash
     PasswordAuthentication yes
     ```

### 2. **Reiniciar el Servicio SSH:**
   - Para aplicar los cambios, reinicia el servicio SSH:
     ```bash
     sudo systemctl restart ssh
     ```

### 3. **Establecer o Cambiar la Contraseña de Root (si es necesario):**
   - Si no tienes una contraseña establecida para `root`, o si la contraseña está bloqueada, establece una nueva:
     ```bash
     sudo passwd root
     ```
   - Ingresa y confirma la nueva contraseña.

### 4. **Conectar como Root vía SSH:**
   - Ahora deberías poder conectarte al servidor remoto como `root` usando la contraseña:
     ```bash
     ssh root@direccion_remota
     ```

### Advertencias de Seguridad:
- **Acceso Root por SSH:** Habilitar el acceso `root` por SSH con contraseña aumenta significativamente el riesgo de seguridad, ya que los atacantes pueden intentar forzar contraseñas para obtener acceso. Es recomendable solo habilitarlo temporalmente para pruebas y deshabilitarlo inmediatamente después.
- **Deshabilitar Después de la Prueba:** Una vez que hayas terminado con tus pruebas, te sugiero que deshabilites nuevamente el acceso `root` por SSH y vuelvas a utilizar claves SSH para mayor seguridad.