# Verificar el consumo de memoria de los contenedores Docker en ejecución

## Para averiguar cuánta memoria están consumiendo los contenedores Docker en ejecución, puedes utilizar el siguiente comando:


docker stats --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}"


Este comando mostrará una tabla con la siguiente información:
- Nombre del contenedor
- Uso de memoria actual
- Porcentaje de uso de memoria

## Si deseas ver solo el uso de memoria sin actualización en tiempo real, puedes usar:


docker ps -q | xargs docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}"


Para obtener información más detallada sobre el uso de memoria de un contenedor específico:


docker inspect -f '{{.State.MemoryStats}}' <nombre_o_id_del_contenedor>


Recuerda reemplazar `<nombre_o_id_del_contenedor>` con el nombre o ID del contenedor que deseas inspeccionar.
