# Problema al iniciar Docker Desktop en Windows: Group membership check

Docker Desktop requiere que tu usuario sea miembro del grupo 'docker-users'.

Para continuar, selecciona Quit y agrega tu usuario al grupo 'docker-users'. Es posible que necesites cerrar sesión y volver a iniciarla para que los cambios surtan efecto.

## El problema

El mensaje que estás recibiendo indica que tu usuario de Windows no está incluido en el grupo docker-users, lo cual es necesario para ejecutar Docker Desktop. Puedes resolver este problema agregando tu usuario a ese grupo.

## Cómo agregar tu usuario al grupo docker-users

### 1. Abrir Administración de equipos

- Haz clic derecho en el menú de inicio de Windows y selecciona "Administración de equipos".
- También puedes abrirlo presionando Win + X y seleccionando "Administración de equipos" o escribiendo "Administración de equipos" en el cuadro de búsqueda del menú de inicio.

### 2. Navegar a Usuarios y Grupos locales

- En la ventana de Administración de equipos, navega hasta "Usuarios y Grupos locales" en el panel izquierdo.

### 3. Seleccionar Grupos

- Haz clic en la carpeta "Grupos" para ver la lista de grupos en tu computadora.

### 4. Buscar y abrir el grupo docker-users

- Busca el grupo llamado "docker-users" y haz doble clic para abrir sus propiedades.

### 5. Agregar tu usuario al grupo

- En la ventana de propiedades del grupo docker-users, haz clic en el botón "Agregar".
- En el campo que dice "Escriba los nombres de objeto para seleccionar", escribe tu nombre de usuario de Windows.
- Haz clic en "Comprobar nombres" para verificar que el nombre de usuario sea correcto.
- Una vez verificado, haz clic en "Aceptar".

### 6. Cerrar sesión y volver a iniciar sesión

- Para que los cambios surtan efecto, cierra sesión en tu cuenta de Windows y vuelve a iniciar sesión.

### 7. Iniciar Docker Desktop

- Ahora intenta iniciar Docker Desktop nuevamente. Debería iniciarse sin el mensaje de error.