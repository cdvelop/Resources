### - Crear una Instantánea (Captura)

Para crear una instantánea de una máquina virtual en su estado actual, puedes usar:

```bash
VBoxManage snapshot "Nombre_de_la_Maquina" take "Nombre_de_la_Instantanea" --live
```

La opción `--live` permite crear la instantánea mientras la máquina está en ejecución. Puedes omitir esta opción si la máquina está apagada.


### - Restaurar una Instantánea

Para restaurar una máquina virtual a una instantánea específica, utiliza:

```bash
VBoxManage snapshot "Nombre_de_la_Maquina" restore "Nombre_de_la_Instantanea"
```


### - Listar snapshots de una máquina virtual
Si tienes una máquina virtual llamada "Debian12":

```bash
VBoxManage snapshot "Debian12" list
```

para omitir la descripción y solo mostrar el nombre de la instantánea:
```bash
VBoxManage snapshot "Debian12" list | grep Name: | awk '{print $2}'
```
