# como ejecuto archivos bash directamente en otra maquina a través de ssh?
ssh usuario@ip_maquina_remota "bash -s" < script.sh
ejemplo:
ssh juanito@192.168.1.100 'bash -s' < script.sh


Este comando permite ejecutar un script Bash en una máquina remota a través de SSH:

1. ssh: Inicia una conexión SSH.
2. usuario@ip_maquina_remota: Especifica el usuario y la dirección IP de la máquina remota.
3. "bash -s": Ejecuta Bash en modo no interactivo (-s) en la máquina remota.
4. < script.sh: Redirige el contenido del archivo script.sh local como entrada para el comando bash en la máquina remota.


