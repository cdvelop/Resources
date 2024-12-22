# Repositorio de ansible para su uso con docker

# Construye la imagen de Docker:
docker build -t my-ansible-image -f Dockerfile .

# 1 asegúrate de tener tus playbooks y otros archivos de Ansible en un directorio en tu máquina host. eg:  
/ruta/a/tus/ansible-files


# Trabajar con Ansible a través de Docker en modo ad-hoc

El modo ad-hoc de Ansible permite ejecutar comandos rápidos y simples sin necesidad de escribir un playbook completo. Cuando se usa con Docker, ofrece la ventaja de tener un entorno Ansible aislado y portable.

Para ejecutar comandos Ansible ad-hoc usando Docker:

1. Asegúrate de tener tu inventario y archivos de configuración en un directorio local.

2. Utiliza el siguiente comando, ajustando las rutas según sea necesario:

   docker run -it --rm -v /ruta/a/tu/directorio:/ansible-books ansible-alpine-minimal ansible all -m [módulo] -a "[argumentos]" -i /ansible-books/tu-inventario

   Donde:
   - [módulo] es el módulo de Ansible que deseas usar (por ejemplo, ping, shell, copy, etc.)
   - [argumentos] son los argumentos específicos para el módulo elegido

Ejemplo de uso:

# Ejecutar un ping a todos los hosts en el inventario
docker run -it --rm -v /playbooks:/ansible-books ansible-alpine-minimal ansible all -m ping -i /ansible-books/inventario

# Ejecutar un comando shell en todos los hosts
docker run -it --rm -v /playbooks:/ansible-books ansible-alpine-minimal ansible all -m shell -a "uptime" -i /ansible-books/inventario

Este método combina la flexibilidad de los comandos ad-hoc de Ansible con la portabilidad y aislamiento de Docker, permitiendo ejecutar tareas rápidas de administración y configuración sin necesidad de instalar Ansible directamente en tu sistema.

docker run -it --rm -v /playbooks:/ansible-books ansible-alpine-minimal ansible all -m ping -i /ansible-books/tu-inventario


# Para entrar en el contenedor y trabajar interactivamente:
docker run -it --rm -v /playbooks:/ansible-books ansible-alpine-minimal /bin/sh


# Para ejecutar y acceder a tus playbooks, usa el siguiente comando:
docker run -it --rm -v /ruta/a/tus/ansible-playbooks:/ansible-books ansible-alpine-minimal

-it: Esto hace que el contenedor sea interactivo y se conecte a tu terminal.
--rm: Elimina el contenedor automáticamente cuando finalices.
-v /ruta/a/tus/ansible-playbooks:/ansible-books: Esto monta el directorio de tu máquina host en el directorio /ansible-books dentro del contenedor.
ansible-alpine-minimal: Este es el nombre que le dimos a nuestra imagen Docker.