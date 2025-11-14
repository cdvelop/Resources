## Restauración de Base de Datos

Si necesitas restaurar una base de datos desde un archivo de respaldo, sigue estos pasos.

1.  **Crear la base de datos de destino (si no existe)**:
    Antes de restaurar, la base de datos que recibirá los datos debe existir en el servidor.

    ```bash
    docker exec pg14-dev createdb -U postgres <nombre_de_tu_db>
    ```
    Por ejemplo, para la base de datos `pa100t`:
    ```bash
    docker exec pg14-dev createdb -U postgres pa100t
    ```

2.  **Copiar el archivo de respaldo al contenedor**:
    Usa `docker cp` para mover tu archivo `.backup` desde tu máquina local al directorio `/tmp/` dentro del contenedor.

    ```bash
    docker cp /ruta/a/tu/backup.backup pg14-dev:/tmp/db.backup
    ```

3.  **Restaurar la base de datos**:
    Ejecuta `pg_restore` dentro del contenedor para importar los datos.

    ```bash
    docker exec -i pg14-dev pg_restore --verbose --clean --no-acl --no-owner -U postgres -d <nombre_de_tu_db> /tmp/db.backup
    ```
    - `--clean`: Limpia (elimina) los objetos de la base de datos antes de recrearlos. Es normal ver errores si la base de datos está vacía, ya que intentará eliminar tablas que no existen.
    - `-d <nombre_de_tu_db>`: Especifica la base de datos a la que se restaurarán los datos.
