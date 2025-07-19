# instalar go en linux deb:


1. obtener
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz 

2. borrar instalaciones anteriores
sudo rm -rf /usr/local/go 

3. instalar
sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin

4. verificar
go version


## Problema: go funciona en la terminal de VS Code pero no en la de GNOME

Esto ocurre porque la variable de entorno PATH es diferente en cada terminal. En VS Code, /usr/local/go/bin está en el PATH, pero en la terminal de GNOME no, por lo que el comando go no se reconoce.

### Solución

Agrega la siguiente línea al final de tu archivo `~/.bashrc` (o `~/.profile` si usas login shell):

```bash
export PATH="/usr/local/go/bin:$PATH"
```

Luego ejecuta:

```bash
source ~/.bashrc
```

Abre una nueva terminal GNOME y verifica con `echo $PATH` que `/usr/local/go/bin` esté presente. Así el comando `go` funcionará igual en todas tus terminales.


