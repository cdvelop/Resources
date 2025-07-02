# configuraciones avanzadas wsl2
https://learn.microsoft.com/en-us/windows/wsl/wsl-config


.wslconfig para configurar ajustes globales.
wsl.conf para configurar ajustes locales.


## Puede verificar si su distribución de Linux (shell) sigue ejecutándose después de cerrar con el comando: 
wsl --list --running
output: There are no running distributions.

## Debe esperar que su distribución Linux deje de funcionar por completo. Esto suele tardar unos 8 segundos.


## El archivo .wslconfig no existe de manera predeterminada. Debe crearse y almacenarse en su %UserProfile% directorio para aplicar estos ajustes de configuración.
La ruta del directorio debería verse así: C:\Users\<UserName>\.wslconfig