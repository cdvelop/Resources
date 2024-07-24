## reconfigurar teclado
sudo dpkg-reconfigure keyboard-configuration

## si no esta instalado o sale el error que no existe paquete
## actualiza repositorio e instalarlo
sudo apt update
sudo apt install keyboard-configuration

## para averiguar en windows que teclado actual tengo configurado
```bash
powershell.exe "Get-WinUserLanguageList"

LanguageTag     : es-CL
Autonym         : Español (Chile)
EnglishName     : Spanish
LocalizedName   : Spanish (Chile)
ScriptName      : Latin
InputMethodTips : {}
Spellchecking   : True
Handwriting     : False
```


