para ver la ip de una máquina virtual
```bash
VBoxManage showvminfo "Debian12" | grep "NIC 1"
```

ver interfaces de red disponibles
```bash
VBoxManage list bridgedifs
```

filtrar las interfaces de red que están en Status Up:
Para filtrar solo las interfaces de red que están en estado "Up" del resultado del comando `VBoxManage list bridgedifs`, puedes combinar el comando con `grep` y `awk`.

```bash
VBoxManage list bridgedifs | awk '/^Name:/{name=$0; sub(/^Name: */, "", name)} /Status:/{if ($2 == "Up") print name}'
```
Explicación:
1. El resultado se pasa a `awk` a través del pipe (`|`).
2. `awk` hace lo siguiente:
   - Cuando encuentra una línea que comienza con "Name:", guarda el nombre de la interfaz.
   - Cuando encuentra una línea con "Status:", comprueba si el estado es "Up". imprime el nombre de la interfaz guardado anteriormente.

filtrar las interfaces de red en estado Up y que de nombre no contengan Virtual Ethernet Adapter:
```bash
VBoxManage list bridgedifs | awk '/^Name:/{name=$0; sub(/^Name: */, "", name)} /Status:/{if ($2 == "Up" && name !~ /Virtual Ethernet Adapter/) print name}'
```

configurar máquina llamada "Debian12" para que use la 1ra interfaz de red física en estado Up:

```bash
VBoxManage modifyvm "Debian12" --bridgeadapter1 "$(VBoxManage list bridgedifs | awk '/^Name:/{name=$0; sub(/^Name: */, "", name)} /Status:/{if ($2 == "Up" && name !~ /Virtual Ethernet Adapter/) {print name; exit}}')"
```

Vamos a desglosar este comando:

1. `VBoxManage modifyvm "Debian12"` es el comando base para modificar la configuración de la máquina virtual llamada "Debian12".

2. `--bridgeadapter1` especifica que queremos configurar el primer adaptador de red en modo puente.

3. está envuelto en `$()` para que se ejecute primero y su salida se use como argumento para `--bridgeadapter1`.

4. Hemos añadido `exit` después de `print name` en el awk para que solo se seleccione la primera interfaz en caso de que haya varias.


Si quieres verificar la configuración:

```bash
# obtener la ip de la máquina virtual
VBoxManage showvminfo "Debian12" | grep "NIC 1"
```