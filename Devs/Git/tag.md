# versionamiento o etiquetado en git

## para ver las etiquetas
git tag

## Ahora, supongamos que olvidaste etiquetar el proyecto en su versión v1.2, la cual corresponde al commit “updated rakefile”. Igual puedes etiquetarlo. Para etiquetar un commit, debes especificar el checksum del commit (o parte de él) al final del comando:
```
$ git tag -a v1.2 9fceb02
```


## etiquetado tardío
`git log --pretty=oneline`
9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
`git tag -a v1.2 9fceb02`


### agregar tag version a un modulo: 
`git tag -a V3.1.1 -m "Print en modulo medical history"`

### Compartir etiquetas es similar a enviar ramas. De manera predeterminada, git push no enviará etiquetas. Las etiquetas se tienen que usar explícitamente en git push
`git push origin v1.4`


[mas comandos](https://www.atlassian.com/es/git/tutorials/inspecting-a-repository/git-tag)


[fuente etiquetado git](https://git-scm.com/book/es/v2/Fundamentos-de-Git-Etiquetado)