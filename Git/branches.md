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
