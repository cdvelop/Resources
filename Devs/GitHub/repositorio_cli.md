# Cree un nuevo repositorio de GitHub desde la línea de comando
[fuente](https://www.techielass.com/create-a-new-github-repository-from-the-command-line/ "www.techielass.com")

El siguiente comando creará un repositorio en GitHub llamado "minuevorepo" . Será un repositorio público. El directorio en el que se encuentra será la fuente de ese repositorio de GitHub y le enviará los archivos del directorio.

```
gh repo create minuevorepo --public --source=. --remote=upstream --push
```