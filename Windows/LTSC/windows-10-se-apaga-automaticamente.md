# Solucion Windows 10 LTSC se apaga cada 1 hora si no se activa
El S.O. Es Una Version De Prueba/Evaluacion Por Lo Cual Es Muy Importante 
Introducir Todos Estos Comandos Para Que El Sistema Operativo Este Estable Y 
Funcional Para Su Correcto Funcionamiento.


## 1 copiar todo el contenido del zip SKUS.zip a la carpeta de:
C:\Windows\System32\spp\tokens\skus

## 2 reiniciar el pc

## 3 luego de reiniciar ejecutar en cmd los comando como administrador
```bash
cscript.exe %windir%\system32\slmgr.vbs /rilc
cscript.exe %windir%\system32\slmgr.vbs /upk >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ckms >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /cpky >nul 2>&1
cscript.exe %windir%\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
clipup -v -o -altto c:\
echo
```

## 4 ejecutar en powerShell como administrador
```shell
irm https://get.activated.win | iex
```
video: https://youtu.be/ZpyupIbkgG0?si=qLufBkHIa40gn0xX

## script para activar windows 10 ltsc 2021
```cmd
cmd.exe /c "activate_windows_ltsc.bat"
```
