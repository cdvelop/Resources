# Errores git Windows
### git status
```bash
$ git status
fatal: detected dubious ownership in repository at 'yo/MiProyecto'
'yo/MiProyecto' is owned by:
        'S-1-5-32-544'
but the current yo is:
        'S-1-5-21-XXXXXX-XXXXX-XXXXX-XXXX'
To add an exception for this directory, call:

        git config --global --add safe.directory yo/MiProyecto
```

La solución proporcionada por git es agregar la carpeta actual a la **safe.directoryvariable** global, de modo que git considere la carpeta como segura. Por lo tanto, proporciona la solución 

```
git config --global --add safe.directory C:/Users/abc/Projects/my-awesome-project
```
Tenga en cuenta que aunque estamos en el entorno de Windows, necesitamos usar la barra inclinada /en lugar de la barra invertida \. Entonces deberías poder ver la variable cuando lo hagas 

`git config --global --list` 

El directorio seguro es una variable de varios valores, por lo que podemos agregar todos los repositorios de carpetas que necesitemos.

> Quien es **_S-1-5-32-544_**, hace referencia al built-in Administrators group de **Microsoft**.


[fuente](https://medium.com/@thecodinganalyst/git-detect-dubious-ownership-in-repository-e7f33037a8f)


