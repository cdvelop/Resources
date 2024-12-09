
para ver las variables de entorno:
```powershell
echo $Env:[variable_name]
```

Process to refresh environment variables without reboot Windows:
Set variable de entorno Command Prompt CMD setx [variable_name] "[variable_value]"
```cmd
setx Test_variable "Variable value"
```
ver la variables:
set
Por ejemplo, si has creado una variable llamada Test_variable, usarías:
   echo %Test_variable%

Esto mostrará el valor de la variable que has establecido.


more info:
https://phoenixnap.com/kb/windows-set-environment-variable
   