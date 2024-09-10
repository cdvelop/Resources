No es necesario esperar a que tu contribución sea aprobada para usar tu nueva funcionalidad en tus propios proyectos. Puedes utilizar la versión de la librería desde tu rama personalizada. Aquí te explico cómo hacerlo:

### 1. **Usar el módulo localmente en tu proyecto**
   Si estás trabajando en tu proyecto localmente y quieres usar la versión modificada de la librería directamente desde tu sistema de archivos, puedes hacer lo siguiente:

   - **Clonar tu fork del repositorio en una ubicación accesible** si no lo has hecho ya:
     ```bash
     git clone https://github.com/tu-usuario/gopdf.git
     ```

   - **Enlazar tu proyecto con la versión modificada**:
     - Si estás utilizando módulos de Go (`go mod`), puedes enlazar tu proyecto para que utilice el código de la versión local de `gopdf`.

     En tu proyecto, abre el archivo `go.mod` y agrega la siguiente línea al final del archivo:
     ```go
     replace github.com/signintech/gopdf => /ruta/al/repo/local/gopdf
     ```
     Esto indicará a Go que use tu copia local de la librería en lugar de la versión remota.

     Por ejemplo:
     ```go
     replace github.com/signintech/gopdf => ../gopdf
     ```

   - **Importar y usar tu versión**:
     Ahora puedes importar `gopdf` como lo harías normalmente, y Go usará tu versión modificada.

### 2. **Utilizar el módulo desde tu fork en GitHub**
   Si prefieres utilizar tu versión desde GitHub y no quieres trabajar con archivos locales, puedes hacer que tu proyecto use el código de tu fork directamente desde la rama que has creado.

   - **Modificar el archivo `go.mod`**:
     Ve a tu archivo `go.mod` y especifica que quieres utilizar la versión desde tu fork y desde tu rama específica. Puedes hacer esto usando un reemplazo temporal en `go.mod`:

     ```go
     require github.com/signintech/gopdf v1.0.0 // versión que estés usando

     replace github.com/signintech/gopdf => github.com/tu-usuario/gopdf feature-support-byte-images
     ```

   - **Ejecutar `go mod tidy`**:
     Después de hacer estos cambios, ejecuta `go mod tidy` para actualizar tus dependencias y descargar tu versión personalizada de `gopdf`.

### 3. **Probar tu nueva funcionalidad**
   Una vez hayas configurado tu proyecto para usar tu versión personalizada, puedes probar la nueva funcionalidad directamente. Al hacer cambios adicionales en tu fork, solo necesitas hacer `git pull` en tu proyecto para obtener los cambios más recientes.

### 4. **Retirar el reemplazo cuando sea aprobado**
   Cuando tu PR sea aprobado y fusionado en el repositorio original de `signintech/gopdf`, puedes eliminar el `replace` en `go.mod` y simplemente utilizar la versión oficial:

   ```bash
   go get -u github.com/signintech/gopdf
   ```

Con estos pasos, podrás utilizar y probar tu nueva funcionalidad sin depender de la aprobación de los mantenedores del proyecto. ¿Te gustaría más detalles sobre alguno de los pasos?