# Instalación de Nebula Graph usando Docker Compose
https://github.com/vesoft-inc/nebula-docker-compose

Siga estos pasos para instalar Nebula Graph utilizando Docker Compose:

1. Clone el repositorio de Nebula Docker Compose:
   
   $ git clone -b release-3.8 https://github.com/vesoft-inc/nebula-docker-compose.git
   

2. Cambie al directorio del repositorio clonado:
   
   $ cd nebula-docker-compose
   

3. Ejecute Docker Compose para iniciar los servicios de Nebula Graph:
   
   $ docker-compose up -d
   

4. Verifique que los contenedores estén en ejecución:
   
   $ docker-compose ps
   

5. Conéctese a Nebula Graph usando la herramienta de línea de comandos Nebula Console:
   
   $ docker run --rm -ti --network nebula-docker-compose_nebula-net --entrypoint=/bin/sh vesoft/nebula-console:v3.8
   

6. Dentro del contenedor de Nebula Console, conéctese al servicio de Nebula Graph:
   
   nebula-console -addr graphd -port 9669 -u root -p nebula
   

7. Una vez conectado, puede comenzar a usar Nebula Graph. Por ejemplo, para mostrar los espacios:
   
   nebula> SHOW SPACES;
   

8. Para detener los servicios cuando haya terminado:
   
   $ docker-compose down
   

Ahora tiene Nebula Graph funcionando en contenedores Docker en su máquina local.
