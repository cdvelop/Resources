Automatizar VirtualBox con Bash mediante la herramienta `VBoxManage`, que se incluye con VirtualBox.

Algunas de esas operaciones básicas:

### - Iniciar una Máquina Virtual

Para iniciar una máquina virtual por ejemplo de nombre Debian12 en modo guiado (con interfaz gráfica):

```bash
VBoxManage startvm "Debian12" --type gui
```

Si prefieres iniciar la máquina en segundo plano (sin interfaz gráfica), puedes usar:

```bash
VBoxManage startvm "Nombre_de_la_Maquina" --type headless
```
### - Apagar una Máquina Virtual

Para apagar una máquina virtual, puedes usar el siguiente comando:

```bash
VBoxManage controlvm "Debian12" acpipowerbutton
```

Esto envía la señal de apagado ACPI, que es similar a presionar el botón de apagado en un equipo físico.

Si la máquina no responde, puedes forzar el apagado:

```bash
VBoxManage controlvm "Debian12" poweroff
```



