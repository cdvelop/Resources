# nebula-graph

NebulaGraph es una base de datos de grafos distribuida, escalable y de alto rendimiento. Está diseñada para manejar grandes volúmenes de datos estructurados en forma de grafos, lo que la hace ideal para aplicaciones que requieren análisis de relaciones complejas entre entidades. NebulaGraph ofrece un lenguaje de consulta similar a SQL llamado nGQL, soporta ACID, y proporciona características avanzadas como particionamiento de grafos y procesamiento de consultas distribuidas.

## Compilación de NebulaGraph en Debian

Para compilar NebulaGraph en Debian, sigue estos pasos:

1. Actualiza el sistema e instala las dependencias necesarias:
   
   sudo apt update
   sudo apt install -y build-essential git cmake libssl-dev libboost-all-dev
   

2. Clona el repositorio de NebulaGraph:
   
   git clone https://github.com/vesoft-inc/nebula.git
   cd nebula
   

3. Crea un directorio para la compilación y entra en él:
   
   mkdir build && cd build
   

4. Ejecuta CMake para configurar el proyecto:
   
   cmake -DCMAKE_INSTALL_PREFIX=/usr/local/nebula -DENABLE_TESTING=OFF ..
   

5. Compila el proyecto:
   make -j$(nproc)  # Compila el proyecto utilizando todos los núcleos disponibles del procesador

$ make -j{N} # E.g., make -j2

   

6. Instala NebulaGraph:
   
   sudo make install
   

7. Verifica la instalación:
   
   /usr/local/nebula/bin/nebula-graphd --version
   

Estos pasos te permitirán compilar e instalar NebulaGraph en tu sistema Debian. Asegúrate de tener suficiente espacio en disco y memoria RAM para el proceso de compilación.

