# Configuración Básica Git

## ver versión instalada
git version

## configurar nombre
git config --global user.name "Juanita Lopez"

## configurar mail
git config --global user.email "juanita.lopez@correo.com"

## ver configuración 
git config --list

## Ignorar archivos con .gitignore

## excluir directorio que no se necesitan en remoto: "/.git/info/exclude
y agregando los directorios que desea al final lo que no se necesita:
```
....
assets/
temp/
secreto.txt
```
