# Tutorial: PostgreSQL 9.5 en Docker + pgAdmin 4 en Debian 12

Este tutorial te guiará para replicar un entorno de producción con PostgreSQL 9.5, utilizando Docker para el motor de la base de datos y pgAdmin 4 como cliente nativo en tu sistema Debian 12.

## Paso 1: Crear el Contenedor Docker con PostgreSQL 9.5

Este directorio contiene 3 archivos:
- `Dockerfile`: Define cómo construir la imagen de Docker. Usa la imagen oficial `postgres:9.5-alpine` y le aplica una configuración personalizada para permitir conexiones remotas.
- `init-db.sh`: El script de configuración que se ejecuta al iniciar el contenedor por primera vez.
- `README.md`: Este mismo archivo.

### Construir la Imagen

1.  **Abre una terminal** en este directorio (`.../Resources/DataBase/postgres-9.5`).
2.  **Ejecuta el siguiente comando** para construir la imagen de Docker. Le daremos el nombre `postgres-replica:9.5`:

    ```bash
    docker build -t postgres-replica:9.5 .
    ```

### Ejecutar el Contenedor

Una vez construida la imagen, puedes iniciar un contenedor.

1.  **Crea el directorio en tu máquina** donde se guardarán los datos persistentes de la base de datos:

    ```bash
    mkdir -p $HOME/Dev/Docker/Volumes/posgre95_volumes/data
    ```

2.  **Crea un archivo `.env`** en este mismo directorio para guardar la contraseña de forma segura.

    ```bash
    echo "POSTGRES_PASSWORD=posgrest" > .env
    ```
    *Puedes cambiar `posgrest` por la contraseña que prefieras dentro de ese archivo.*

3.  **Ejecuta este comando** para iniciar el contenedor. Usará el archivo `.env` para la configuración y montará el volumen que creaste:

    ```bash
    docker run --name pg95-dev --restart unless-stopped --env-file .env -p 5432:5432 -v $HOME/Dev/Docker/Volumes/posgre95_volumes/data:/var/lib/postgresql/data -d postgres-replica:9.5
    ```

    **Desglose del comando:**
    *   `--name pg95-dev`: Le da un nombre fácil de recordar al contenedor.
    *   `--restart unless-stopped`: **Política de reinicio**. Hace que el contenedor se inicie automáticamente con Docker, a menos que lo detengas manualmente.
    *   `--env-file .env`: Carga las variables de entorno (en este caso, la contraseña) desde el archivo `.env`.
    *   `-p 5432:5432`: Mapea el puerto 5432 del contenedor al puerto 5432 de tu máquina.
    *   `-v $HOME/Dev/Docker/Volumes/posgre95_volumes/data:/var/lib/postgresql/data`: Mapea el directorio de tu máquina con el directorio de datos de PostgreSQL dentro del contenedor.
    *   `-d`: Ejecuta el contenedor en modo "detached" (en segundo plano).
    *   `postgres-replica:9.5`: El nombre de la imagen que creamos.

4.  **Para verificar que el contenedor está corriendo**, usa el comando:
    ```bash
    docker ps
    ```
    Deberías ver `pg95-dev` en la lista.

## Paso 2: Instalar pgAdmin 4 en Debian 12

Sigue los pasos oficiales para instalar pgAdmin 4.

1.  **Instalar dependencias y la clave del repositorio:**
    ```bash
    sudo apt-get install -y curl ca-certificates gnupg
    curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
    ```

2.  **Añadir el repositorio de pgAdmin:**
    ```bash
    sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt-get update'
    ```

3.  **Instalar pgAdmin 4 (modo escritorio y web):**
    ```bash
    sudo apt-get install -y pgadmin4
    ```
    *Esto instalará tanto la aplicación de escritorio como el servidor web. Puedes usar la que prefieras.*

## Paso 3: Conectar pgAdmin 4 a la Base de Datos Docker

1.  **Abre pgAdmin 4** desde el menú de aplicaciones de tu sistema.
2.  Haz clic derecho en `Servers` -> `Create` -> `Server...`.
3.  **En la pestaña `General`:**
    *   **Name:** Ponle un nombre descriptivo, como `PostgreSQL 9.5 (Docker)`.
4.  **En la pestaña `Connection`:**
    *   **Host name/address:** `localhost`
    *   **Port:** `5432`
    *   **Maintenance database:** `postgres`
    *   **Username:** `postgres`
    *   **Password:** La contraseña que pusiste en el archivo `.env` (ej: `posgrest`).
5.  Haz clic en **`Save`**.

¡Listo! Ahora deberías ver tu servidor en la lista y podrás administrar tu base de datos PostgreSQL 9.5 que corre en Docker, usando un cliente moderno y nativo en tu sistema.
