# Branches 
_(Ramas)_

### crear una nueva rama al proyecto
`git branch new_feature`

### cambiarnos a la nueva rama
`git checkout new_feature`

### ver ramas
`git branch`

### ver ramas locales y remotas
`git branch -a`

### agregar cambios rama nueva al remoto
```bash
git add -A
git commit -m "nueva rama"
git push -u origin new_feature
```


## Unir rama new_feature a master

1. nos cambiamos a master
    - `git checkout master`

2. verificamos que tenemos ultima versión
    - `git pull origin master`
    #### - ver ramas unidas anteriormente
    - `git branch --merged`

3. meter cambios rama new_feature a master
    - `git merge new_feature `

4. subir cambios a repo remoto
    - `git push origin master `

5. borrar rama new_feature remoto
    - `git push origin --delete new_feature`

6. borrar rama new_feature local
    - `git branch -d new_feature`

## renombrar rama

### 1. **Si ya estás en la rama que quieres renombrar**
Ejecuta lo siguiente en tu terminal:
```sh
git branch -m nuevo-nombre
```
Esto renombrará la rama actual al `nuevo-nombre`.

### 2. **Si NO estás en la rama que quieres renombrar**
Si deseas renombrar otra rama sin cambiar a ella, usa:
```sh
git branch -m antiguo-nombre nuevo-nombre
```

### 3. **Actualizar el branch en el repositorio remoto**
Si la rama ya está en el remoto y quieres reflejar el cambio:
```sh
git push origin -u nuevo-nombre
git push origin --delete antiguo-nombre  # Eliminar la versión anterior en remoto
```

### 4. **Actualizar referencias en otros clones del repositorio**
Si otros han clonado el repositorio, deben ejecutar:
```sh
git fetch origin
git checkout nuevo-nombre
git branch --unset-upstream
git branch -u origin/nuevo-nombre
```

Así, la referencia local se actualizará con la nueva rama en el remoto. 🚀
