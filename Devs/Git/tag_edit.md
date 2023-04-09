## ¿Cómo cambiar el nombre de una etiqueta en Git?

git tag [new_tag_name] [old_tag_name]

## ejemplo:

git tag v1.7 v1.6

## Etiquetas anotadas
La sintaxis para cambiar el nombre de una etiqueta anotada es:

git tag -a [new_tag] [old_tag]^{} -m [new_message]

## ejemplo:

git tag -a v1.7 v1.6^{} -m "Version 1.7 released"

## Eliminar etiqueta en el repositorio local:

git tag -d [old_tag_name]

## Por ejemplo:

git tag -d v1.6

## Eliminar etiqueta en repositorio remoto.

git push origin [new_tag_name] :[old_tag_name]

## Por ejemplo:

git push origin v1.8 :v1.7

## Cambiar el nombre de una etiqueta en un repositorio remoto. Los dos puntos eliminan la etiqueta anterior ( v1.7) del repositorio remoto y la reemplazan por la nueva ( v1.8).


## Paso 3: Asegúrese que sus colaboradores ejecuten el siguiente comando para limpiar sus repositorios e implementar cualquier cambio de etiqueta que haya realizado:

git pull --prune --tags

Conclusión

Este tutorial mostró cómo cambiar el nombre de etiquetas Git ligeras y anotadas en un repositorio local y remoto.

fuente:

https://phoenixnap.com/kb/git-rename-tag