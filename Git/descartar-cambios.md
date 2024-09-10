
# Descartar cambios en Git

Existen varias formas de descartar cambios en Git, dependiendo de la situación:

1. Descartar cambios en archivos no rastreados (untracked):
   
   ```bash 
   git clean -fd
   ```
   
   Esto eliminará todos los archivos y directorios no rastreados.

2. Descartar cambios en archivos modificados pero no agregados al área de preparación:
   ```bash 
   git checkout -- <archivo>
   ```
   
   o para descartar todos los cambios:
   ```bash 
   git checkout -- .
   ```

3. Descartar cambios en archivos agregados al área de preparación (staged):
   
   git reset HEAD <archivo>
   
   Esto moverá los cambios del área de preparación de vuelta al directorio de trabajo.
   Luego, puedes usar `git checkout -- <archivo>` para descartar los cambios.

4. Descartar cambios en el último commit:
   
   git reset --hard HEAD~1
   
   Esto eliminará el último commit y todos los cambios asociados.

5. Revertir un commit específico:
   
   git revert <hash-del-commit>
   
   Esto creará un nuevo commit que deshace los cambios del commit especificado.

Recuerda que estas operaciones pueden resultar en pérdida de datos, así que úsalas con precaución.
