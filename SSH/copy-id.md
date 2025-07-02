# Comando ssh-copy-id

El comando `ssh-copy-id` es una herramienta útil para copiar tu clave pública SSH a un servidor remoto de forma segura y automática. Este comando simplifica el proceso de configuración de autenticación por clave pública para conexiones SSH.

Funcionalidad principal:
- Copia la clave pública del usuario al archivo `~/.ssh/authorized_keys` del servidor remoto.
- Configura los permisos correctos en el directorio y archivo de destino.

Sintaxis básica:

ssh-copy-id [opciones] [usuario@]hostname

Opciones comunes:

-i <archivo_clave>: Especifica la clave pública a copiar. Por defecto, usa ~/.ssh/id_rsa.pub.
-f: Fuerza la copia, incluso si la clave ya existe en el servidor remoto.
-n: Realiza una ejecución en seco, mostrando lo que se haría sin realizar cambios.
-p <puerto>: Especifica un puerto SSH diferente al predeterminado (22).
-o <opción_ssh>: Pasa opciones adicionales al comando SSH subyacente.

[usuario@]hostname: Especifica el servidor de destino y, opcionalmente, el nombre de usuario.

Beneficios:
1. Automatiza el proceso de configuración de autenticación por clave.
2. Evita errores manuales al copiar y pegar claves.
3. Mejora la seguridad al configurar correctamente los permisos.

Ejemplo de uso:

ssh-copy-id usuario@ejemplo.com


Este comando copiará tu clave pública predeterminada (generalmente `~/.ssh/id_rsa.pub`) al servidor `ejemplo.com` para el usuario especificado.

Nota: Asegúrate de tener una clave SSH generada antes de usar este comando. Si no tienes una, puedes crearla con `ssh-keygen`.