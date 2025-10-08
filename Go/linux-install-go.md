# Instalar go en Linux:

1. abre tu terminal y ve al directorio descargas
```bash
cd ~/Downloads
```

2. obtener go desde la url oficial **https://go.dev/dl/**
```bash
wget https://go.dev/dl/go1.25.2.linux-amd64.tar.gz 
```

3. borrar instalaciones anteriores si las hay
```bash
sudo rm -rf /usr/local/go 
```

4. descomprime y instalar
```bash
sudo tar -C /usr/local -xzf go1.25.2.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin
```

5. verificar
```bash
go version
```

6. instalar las herramientas de compilacion (normalmente las instala automaticamente vsc cuando se usa ese editor)
```bash
go install golang.org/x/tools/gopls@latest
```

7. borrar la descarga
```bash
rm -rf go1.25.2.linux-amd64.tar.gz
```
---

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




