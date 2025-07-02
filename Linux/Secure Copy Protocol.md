# Secure Copy Protocol (SCP)

El Protocolo de Copia Segura (SCP, por sus siglas en inglés) es una herramienta de transferencia de archivos que permite la copia segura de archivos entre un host local y un host remoto o entre dos hosts remotos. Utiliza el protocolo SSH (Secure Shell) para la autenticación y el cifrado de datos durante la transferencia.

Características principales:

1. Seguridad: Utiliza cifrado para proteger la información durante la transferencia.
2. Autenticación: Requiere autenticación de usuario para acceder a los sistemas remotos.
3. Integridad: Garantiza que los archivos se transfieran sin alteraciones.
4. Eficiencia: Proporciona una transferencia de archivos rápida y confiable.

Uso básico:

scp [opciones] archivo_origen usuario@host_destino:ruta_destino


Ejemplos:
- Copiar un archivo local a un servidor remoto:
  
  scp archivo.txt usuario@servidor.com:/ruta/destino/
  

- Copiar un archivo desde un servidor remoto a la máquina local:
  
  scp usuario@servidor.com:/ruta/origen/archivo.txt /ruta/local/destino/

- Copiar un directorio completo:
  scp -r directorio_local usuario@servidor.com:/ruta/destino/

  ej:
  scp -r ~/Projects/Working/vps-setup root@192.168.0.21:/tmp/vps-setup

  

SCP es una herramienta esencial para administradores de sistemas y desarrolladores que necesitan transferir archivos de manera segura entre sistemas.

# copiar solo archivos de una extension determinada
`scp` no tiene una opción específica para copiar solo archivos de un tipo determinado, como los archivos `.sh`. Sin embargo, puedes combinar `find` con `scp` para lograrlo. Aquí te muestro cómo hacerlo:

### Copiar Solo Archivos `.sh` Desde tu Máquina Local a un Servidor Remoto

1. **Usar `find` para listar los archivos `.sh` y `scp` para copiarlos:**

   ```bash
   find ~/Projects/Working/vps-setup -name "*.sh" -exec scp {} root@192.168.0.21:/tmp/vps-setup \;
   ```

   - `find ~/Projects/Working/vps-setup -name "*.sh"`: Encuentra todos los archivos `.sh` en el directorio `~/Projects/Working/vps-setup`.
   - `-exec scp {} root@192.168.0.21:/tmp/ \;`: Ejecuta `scp` para cada archivo encontrado, copiándolos al directorio `/tmp/` en el servidor remoto.
   - scp necesita estar completo y terminar con \; para indicar el fin de la acción.

### Copiar Solo Archivos `.sh` Desde un Servidor Remoto a tu Máquina Local

1. **Usar `ssh` con `find` y `scp` para copiar los archivos `.sh`:**

   ```bash
   ssh root@192.168.0.21 'find /ruta/remota/del/directorio -name "*.sh"' | while read file; do
       scp root@192.168.0.21:"$file" ~/Projects/Working/temp/
   done
   ```

   - `ssh root@192.168.0.21 'find /ruta/remota/del/directorio -name "*.sh"'`: Ejecuta `find` en el servidor remoto para listar todos los archivos `.sh`.
   - `while read file; do scp root@192.168.0.21:"$file" ~/Projects/Working/temp/; done`: Copia cada archivo listado al directorio `~/Projects/Working/temp/` en tu máquina local.

### Consideraciones Adicionales

- **Directorio de Destino**: Asegúrate de que el directorio de destino en el servidor remoto o en tu máquina local existe antes de ejecutar los comandos.

- **Permisos**: Verifica que tienes permisos adecuados para leer y escribir en los directorios de origen y destino.

Estos métodos te permiten copiar archivos `.sh` sin tener que copiar todo el directorio. Asegúrate de ajustar las rutas y permisos según sea necesario para tu entorno específico.

