# intercambio de ssh key entre windows y wsl2

Ahora, se te pedirá que ingreses tu frase de contraseña cada vez que intentes enviar un mensaje a Github. Esto se volverá aburrido rápidamente. Esto se debe a que el agente ssh no se está ejecutando en el lado de Linux. Para que el agente se ejecute cuando se inicia WSL, primero instala Keychain .
```bash
sudo apt-get update
sudo apt-get install keychain

# edita el archivo: 
nano ~/.bashrc

# agrega al final de tu archivo .bashrc en wsl:
# Start SSH agent
eval $(keychain --eval --quiet id_rsa)

# recarga el archivo .bashrc
source ~/.bashrc

```


