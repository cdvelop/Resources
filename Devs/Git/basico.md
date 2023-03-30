# Comandos Básicos Git

### iniciar proyecto nuevo:
`git init`

### ver estado de archivos
`git status`

### agregar archivos sin seguimiento a staging area
`git add -A`

### Eliminar archivo staging area
`git rm --cached archivo.txt`

### agregar todos los archivos
`git add .`

### hacer commit para agregar archivos al repositorio
`git commit -m "inicio"`

### ver todos los commit
`git log`

### ver commits en linea
`git log --pretty=oneline`

---


git branch -M main

### agregar repositorio remoto: 
`git remote add origin https://github.com/usuario/proyecto.git`

# subir actualización local al remoto:
`git push -u origin main`

### si no funciona por ej si ya existe o tiene data se puede forzar:
`git push --force https://github.com/usuario/proyecto.git`

### ejemplo inicio comandos
```bash
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/usuario/proyecto.git
git push -u origin main
```


### Borramos todo el historial y los registros de Git pero guardamos los cambios que tengamos en Staging, asi podemos aplicar las ultimas actualizaciones a un nuevo commit.
`git reset --soft`

### Borra todo. , absolutamente todo. Toda la información de los commits y del area de staging se borra del historial.
`git reset --hard`

### agregar tag version a un modulo: 
`git tag -a V3.1.1 -m "Print en modulo medical history"`

### ver tag (version): 
`git tag`
