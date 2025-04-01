https://www.youtube.com/watch?v=Lt7l5tDzk_U
abre una terminal y ejecuta los siguientes comandos:

```bash
# ver version de windows server 2012
DISM /online /Get-TargetEditions

# según la version de windows server 2012 que tengas, ejecuta uno de los siguientes comandos con la clave de producto correspondiente:
DISM /online /Set-Edition:ServerDatacenter /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

# para los que no les funciona la clave de datacenter: 
DISM /online /Set-Edition:ServerDatacenter /ProductKey:Y4TGP-NPTV9-HTC2H-7MGQ3-DV4TW /AcceptEula
```




DISM /online /Set-Edition:ServerStandard /ProductKey:DBGBW-NPF86-BJVTX-K3WKJ-MTB6V /AcceptEula

DISM /online /Set-Edition:ServerStandard /ProductKey:DBGBW-NPF86-BJVTX-K3WKJ-MTB6V /AcceptEula


Windows server 2012 Standard - XC9B7-NBPP2-83J2H-RHMBY-92BT4  �  DBGBW-NPF86-BJVTX-K3WKJ-MTB6V
 
Windows server 2012 Datacenter - 48HP8-DN98B-MYWDG-T2DCC-8W83P