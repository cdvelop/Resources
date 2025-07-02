
# embeber archivos estáticos en la app
ej assets/logo.png

el el archivo go donde se encuentra
la carpeta en este caso assets
agregas en la cabecera
```go
//go:generate fyne bundle -o bundled.go assets
```
 y en la terminal digitas
 ```bash
 go generate

 # este comando genera el archivo bundled.go con el contenido de la carpeta assets para su uso en la app
 ```
