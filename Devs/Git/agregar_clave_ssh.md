
# Configurar la autenticación SSH para Git Bash en Windows
Setup SSH Authentication for Git Bash on Windows

## Preparación
1. Cree una carpeta en la raíz de su carpeta de inicio de usuario (Ejemplo: C:/Users/username/) llamada .ssh.
Puedes ejecutar algo como:mkdir -p ~/.ssh

2. Cree los siguientes archivos si aún no existen (las rutas comienzan desde la raíz de la carpeta de inicio de su usuario):
```
touch ~/.ssh/config
touch ~/.bash_profile
touch ~/.bashrc
```

## Crear una nueva clave SSH
Siga los pasos de la sección denominada "Generación de una nueva clave SSH" que se encuentra en la siguiente documentación de GitHub: [Generación de una nueva clave SSH y adición a ssh-agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#platform-windows)


### Configurar SSH para el servidor de alojamiento Git
Puede usar su editor de texto favorito: nano, vim, subl, atom, code
por ejemplo, ejecute: 
code ~/.ssh/config

### Luego, agregue las siguientes líneas .ssh/config que deben encontrarse en la raíz de la carpeta de inicio de su usuario:

```bash
AddKeysToAgent yes
Host github.com
 Hostname github.com
 IdentityFile ~/.ssh/id_rsa
```

## Habilite el inicio del agente SSH siempre que se inicie Git Bash
Ejecute su editor, por ejemplo, code ~/.bash_profile y agregue las siguientes líneas:

```bash
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
```

## Ejecute su editor, por ejemplo, code ~/.bashrc y agregue el siguiente fragmento::
```bash
# Start SSH Agent
#----------------------------

SSH_ENV="$HOME/.ssh/environment"

function run_ssh_env {
  . "${SSH_ENV}" > /dev/null
}

function start_ssh_agent {
  echo "Initializing new SSH agent..."
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo "succeeded"
  chmod 600 "${SSH_ENV}"

  run_ssh_env;

  ssh-add ~/.ssh/id_rsa;
}

if [ -f "${SSH_ENV}" ]; then
  run_ssh_env;
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_ssh_agent;
  }
else
  start_ssh_agent;
fi
```
## fuente:
https://gist.github.com/jherax/979d052ad5759845028e6742d4e2343b



# otros comandos para agregar clave llave ssh y no vuelva a pedirla que probe anteriormente:
## ej:
ssh-add

## en caso de error: "Could not open a connection to your authentication agent."
exec ssh-agent bash
## después ya puedes probar nuevamente

## usuarios windows
ssh-add "C:\\Users\\<your user>/.ssh/id_rsa"


### Si lo ha intentado ssh-add y aún se le solicita que ingrese su frase de contraseña, intente usar ssh-add -K. Esto agrega su frase de contraseña a su llavero.

### Lo que funcionó para mí en Windows fue (primero había clonado el código de un repositorio):

eval $(ssh-agent)
ssh-add 
git pull 