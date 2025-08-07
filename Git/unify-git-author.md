pare ver los autores:

```bash
git log --format='%an <%ae>' | sort | uniq
```


## unificar nombres de autores
Si quieres unificar los nombres de los autores, puedes usar el siguiente comando:

```bash
git filter-branch --env-filter '
if [ "$GIT_AUTHOR_NAME" = "OLDER_AUTOR_NAME_JUANITO" ] || [ "$GIT_COMMITTER_NAME" = "OLDER_AUTOR_NAME_JUANITO" ]; then
    export GIT_AUTHOR_NAME="NEW_AUTHOR_NAME_MARIA"
    export GIT_AUTHOR_EMAIL="NEW_AUTHOR_EMAIL+MARIA@users.noreply.github.com"
    export GIT_COMMITTER_NAME="NEW_AUTHOR_NAME_MARIA"
    export GIT_COMMITTER_EMAIL="NEW_AUTHOR_EMAIL+MARIA@users.noreply.github.com"
fi
' --tag-name-filter cat -- --all
```

## forzar el push
Si has cambiado los autores, necesitarás forzar el push al repositorio remoto:
```bash
git push --force origin main
```

## para que se sigan usando el nuevo nombre y email
Para que los nuevos commits usen el nuevo nombre y email, puedes configurar tu usuario globalmente:
```bash
git config --global user.name "NEW_AUTHOR_NAME_MARIA"
git config --global user.email "NEW_AUTHOR_EMAIL+MARIA@users.noreply.github.com"
```