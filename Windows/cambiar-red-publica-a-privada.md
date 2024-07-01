# Cambiar de red pública a privada en Windows 10

ejecuta power shell como administrador
- obtén el indice de tu conexión
Get-NetConnectionProfile
- configura la red privada
Set-NetConnectionProfile -InterfaceIndex 8 -NetworkCategory Private