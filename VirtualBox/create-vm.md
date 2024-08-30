# crear maquina virtualBox con bash

1. descargar la iso del sistema operativo debian en linux
```bash
wget -P "$HOME/Downloads" https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.6.0-amd64-netinst.iso

```

1. descargar la iso en windows
```bash
curl -L -o "$HOME/Downloads/debian-12.6.0-amd64-netinst.iso" https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.6.0-amd64-netinst.iso
```
Sí, existe una versión más pequeña de la instalación de Debian llamada **"netboot"** o también **"mini.iso**. Esta imagen es aún más ligera que la versión "netinst", generalmente pesando alrededor de 30 MB a 100 MB. Sin embargo, la instalación depende de tener una conexión a Internet activa, ya que descargará la mayor parte de los paquetes durante el proceso de instalación.

Para Debian 12, puedes encontrar la versión "mini.iso" en los directorios de imágenes netboot:

- [Imagen de netboot para amd64](https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/mini.iso)


Estas imágenes son ideales si deseas una instalación ligera y descargable rápidamente, y te encuentras en un entorno con buena conectividad a Internet.

Ten en cuenta que durante la instalación, esta imagen descargará los componentes necesarios desde los servidores de Debian, por lo que el tiempo total de instalación dependerá de la velocidad de tu conexión a Internet.