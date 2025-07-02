## llamar script desde el terminal gitbash

agrega esta linea al final del archivo .bashrc de tu directorio personal con la carpeta que contenga tus script

```bash
export PATH=$PATH:/c/Users/TU_USUARIO/TU_CARPETA_DE_SCRIPTS
```

guarda el archivo .bashrc, cierra y vuelve abrir el terminal bash.
ahora ya puedes llamar a tus script ("miScript.sh") desde cualquier lugar. 

## script ejemplo para renombrar etiquetas en local y remoto
```bash
#!/bin/bash
echo "Ingrese el nombre de la etiqueta antigua: ej v4.4.2"
read old_tag
echo "Ingrese el nombre de la nueva etiqueta: "
read new_tag

git fetch --all
git tag "$new_tag" "$old_tag"
git tag -d "$old_tag"
git push origin :refs/tags/"$old_tag"
git push --tags
```