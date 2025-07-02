# tutorial
- windows
https://youtu.be/BpaqD8Bh8BI?si=2E5vUhPrjrXcSi6e

- linux
https://youtu.be/cxKOffto4MU?si=q_R9i_kH2pJp_4QC

- docker vs podman
https://youtu.be/Mc_kAf0UkmY?si=gLZA37N8XN2BpeUA



```bash
# hello world podman
 podman run quay.io/podman/hello
 ```	

```bash	
# buscar imágenes en quay.io
podman search quay.io/postgres
```
```bash
# buscar imágenes en docker hub
podman search docker.io/postgres
```
```bash
# para descargar una imagen
podman pull docker.io/postgres
```
```bash
# para ver las imágenes que tenemos descargadas
podman images
```
```bash
# para ver los contenedores que tenemos corriendo
# podman ps
# con detalles
podman ps -a
```
```bash
# detener un contenedor
podman stop 0dc1c0555893
```
```bash
# para eliminar un contenedor
podman rm 6ec8243c561d
```