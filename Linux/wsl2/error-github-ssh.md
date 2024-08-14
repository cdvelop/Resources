# error al realizar git push: 
```bash	
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

Para usar las credenciales SSH que tienes configuradas en Windows desde WSL2, puedes crear un enlace simbólico (symlink) en tu sistema de archivos WSL2 que apunte a la ubicación de las claves SSH en Windows. 

# TUTORIAL INTERCAMBIO DE CLAVE SSH ENTRE WINDOWS Y WSL2:
https://almontasser.ly/blog/sharing-ssh-keys-between-windows-and-wsl2


# prueba la conexión SSH a github.com:
```bash
ssh -T git@github.com
```
# si funciona, debería ver algo como:
```bash
Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

si tiene este error:
```bash
ssh -T git@github.com
Bad owner or permissions on /home/USER_NAME/.ssh/config
```
- Esto significa que el archivo de configuración SSH (config) no tiene los permisos correctos. Asegúrate de que el archivo tenga los permisos 600 (solo el propietario puede leer y escribir).

- Verifica los permisos del archivo:
En tu terminal de Debian (WSL), ejecuta el siguiente comando para verificar los permisos del archivo config:
```bash	
ls -l ~/.ssh/config
```
- Si los permisos no son -rw------- (solo lectura y escritura para el usuario actual), necesitarás ajustarlos:
```bash
sudo chown USER_NAME:USER_NAME ~/.ssh/config
# donde USER_NAME es tu nombre de usuario en WSL (por ejemplo, ubuntu, debian).
sudo chmod 600 ~/.ssh/config
# 600 significa que solo el propietario puede leer y escribir en el archivo.
```