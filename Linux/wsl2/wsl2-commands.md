# ver verciones de wsl
wsl -l -v

# ver distros instaladas
wsl --list
# mas detalle
wsl --list --verbose


# ejecutar comando en una distro determinada
wsl --distribution Debian --exec neofetch
o
wsl -d Debian -e neofetch
-u (usuario)

# asignar distro por defecto en wsl
wsl --set-default Debian
o
wsl -s Debian

# detener todas las distros
wsl --shutdown

# desinstalar una distro (elimina todos los datos)
wsl --unregister Debian

# exportar configuración de una distro (clonar)
wsl --export Debian C:\Users\usuario\Desktop\debianNew.tar

# importar configuración de una distro
wsl --import <NombreDistroACrear> 
<UbicacionDeLaCarpetaDeLaDistro> <UbicacionDelArchivoDeLaDistroExportado>
ej:
wsl --import Debian2 C:\Users\usuario\Distros\
C:\Users\usuario\Desktop\debianNew.tar