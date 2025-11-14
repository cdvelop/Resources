# Tutorial: PostgreSQL 14 en Docker + pgAdmin 4 en Debian 12

Este tutorial te guiará para crear un entorno de desarrollo moderno con PostgreSQL 14, utilizando Docker para el motor de la base de datos y pgAdmin 4 como cliente nativo en tu sistema Debian 12.

## Paso 1: Crear el Contenedor Docker con PostgreSQL 14

Este directorio contiene 4 archivos:
- `Dockerfile`: Define cómo construir la imagen de Docker. Usa la imagen oficial `postgres:14-alpine` y le aplica una configuración personalizada.
- `init-db.sh`: Un script que configura la base de datos para aceptar conexiones remotas.
- `.env`: Un archivo para guardar la contraseña de forma segura.
- `README.md`: Este mismo archivo.

### Construir la Imagen

1.  **Abre una terminal** en este directorio (`.../Resources/DataBase/postgres-14`).
2.  **Ejecuta el siguiente comando** para construir la imagen de Docker. Le daremos el nombre `postgres-replica:14`:

    ```bash
    docker build -t postgres-replica:14 .
    ```

### Ejecutar el Contenedor

Una vez construida la imagen, puedes iniciar un contenedor.

1.  **Crea el directorio en tu máquina** donde se guardarán los datos persistentes de la base de datos:

    ```bash
    mkdir -p $HOME/Dev/Docker/Volumes/postgres14_volumes/data
    ```

2.  **Ejecuta este comando** para iniciar el contenedor. Usará el archivo `.env` para la configuración y montará el volumen que creaste:

    ```bash
    docker run --name pg14-dev --restart unless-stopped --env-file .env -p 5432:5432 -v $HOME/Dev/Docker/Volumes/postgres14_volumes/data:/var/lib/postgresql/data -d postgres-replica:14
    ```

    **Desglose del comando:**
    *   `--name pg14-dev`: Le da un nombre al contenedor.
    *   `--restart unless-stopped`: Hace que el contenedor se inicie automáticamente con el sistema.
    *   `--env-file .env`: Carga la contraseña desde el archivo `.env`.
    *   `-p 5432:5432`: Mapea el puerto de la base de datos a tu máquina.
    *   `-v $HOME/Dev/Docker/Volumes/postgres14_volumes/data:/var/lib/postgresql/data`: Mapea el directorio de datos a tu máquina local.
    *   `-d`: Ejecuta el contenedor en segundo plano.
    *   `postgres-replica:14`: El nombre de la imagen que creamos.

3.  **Para verificar que el contenedor está corriendo**, usa el comando:
    ```bash
    docker ps
    ```

## Paso 2: Conectar pgAdmin 4 a la Base de Datos

1.  **Abre pgAdmin 4**.
2.  Crea una nueva conexión de servidor con los siguientes datos:
    *   **Pestaña `General` -> Name:** `PostgreSQL 14 (Docker)`
    *   **Pestaña `Connection` -> Host name/address:** `localhost`
    *   **Pestaña `Connection` -> Port:** `5432`
    *   **Pestaña `Connection` -> Maintenance database:** `postgres`
    *   **Pestaña `Connection` -> Username:** `postgres`
3.  Guarda la conexión. Cuando intentes conectar, te pedirá la contraseña.
    *   **Password:** La que pusiste en el archivo `.env` (ej: `posgrest`).

Con esto, tendrás un entorno de PostgreSQL 14 moderno, robusto y totalmente compatible con pgAdmin 4.

