# error al realizar git push: 
```bash	
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```
# solución
Para usar las credenciales SSH que tienes configuradas en Windows desde WSL2, puedes crear un enlace simbólico (symlink) en tu sistema de archivos WSL2 que apunte a la ubicación de las claves SSH en Windows. Aquí te dejo los pasos para hacerlo:

1. Primero, asegúrese de que el servicio de agente SSH de Windows esté en ejecución. Puede hacerlo desde PowerShell con permisos de administrador:
```bash
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
```
2. En su terminal de Debian en WSL2, edite o cree el archivo de configuración SSH:
```bash
nano ~/.ssh/config
```
3. Agregue las siguientes líneas al archivo:
```bash	
Host github.com
    HostName github.com
    IdentityFile /mnt/c/Users/*MY_USER*/.ssh/id_rsa
    IdentityAgent /mnt/c/Windows/System32/OpenSSH/ssh-agent.exe

# Asegúrese de reemplazar MY_USER con su nombre de usuario de Windows y id_rsa con el nombre de su clave privada si es diferente.
```
4. Guarde y cierre el archivo (en nano, presione Ctrl+X, luego Y, luego Enter).

5. Ahora, necesitamos asegurarnos de que WSL2 pueda comunicarse con el agente SSH de Windows. Agregue estas líneas a su archivo ~/.bashrc en su consola wsl2 (ubuntu,debian.):
```bash
nano ~/.bashrc
```
```bash
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Windows/System32/OpenSSH/ssh-agent.exe" &) >/dev/null 2>&1
fi
```
6. Guarde y cierre el archivo (en nano, presione Ctrl+X, luego Y, luego Enter).
```bash
source ~/.bashrc
``` 
7. Asegúrese de que su clave esté añadida al agente SSH de Windows. Desde PowerShell en Windows:
```powershell
ssh-add C:\Users\MY_USER\.ssh\id_rsa
```
8. prueba la conexión SSH a github.com por ejemplo:
```bash
ssh -T git@github.com
```
9. si funciona, debería ver algo como:
```bash
Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```
10. si ves este error:
```bash
ssh -T git@github.com
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0777 for '/mnt/c/Users/YOU_USER_NAME/.ssh/id_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "/mnt/c/Users/YOU_USER_NAME/.ssh/id_rsa": bad permissions
git@github.com: Permission denied (publickey).
```
- Este aviso aparece porque los permisos del archivo de tu clave privada (id_rsa) son demasiado abiertos, lo que significa que otros usuarios en el sistema podrían acceder a él. Para proteger tu clave privada, debes restringir los permisos del archivo

VAMOS AQUI nuevamente


- Probar la conexión con GitHub:
    ```bash	
    ssh -T git@github.com
    ```