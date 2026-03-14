# Mejorar resolución de video en VMs QEMU/KVM (Windows)

## Paso 1: Cambiar modelo de video a QXL

Apagar la VM y editar la configuración:
```bash
sudo virsh shutdown <nombre-vm>
sudo virsh edit <nombre-vm>
```

Buscar la sección `<video>` y cambiar el modelo a `qxl`:
```xml
<video>
  <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
</video>
```

## Paso 2: Cambiar display a SPICE

En la misma edición, buscar `<graphics>` y cambiar a:
```xml
<graphics type='spice' autoport='yes'>
  <listen type='address' address='127.0.0.1'/>
</graphics>
```

Guardar y salir (ctrl+o, ctrl+x).

## Paso 3: Descargar ISO de virtio-win

```bash
wget -O /tmp/virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```

## Paso 4: Montar la ISO como CD en la VM

```bash
sudo virsh attach-disk <nombre-vm> /tmp/virtio-win.iso sdb --type cdrom --mode readonly --config
```

## Paso 5: Iniciar la VM e instalar drivers

```bash
sudo virsh start <nombre-vm>
```

Dentro de la VM:
1. Abrir el CD (unidad D: o E:)
2. Ejecutar `virtio-win-gt-x64.msi` o `virtio-win-guest-tools.exe`
3. Seguir el asistente de instalación (instala drivers QXL, VirtIO, SPICE agent)
4. Reiniciar la VM

## Paso 6: Ajustar resolución

Después de instalar los drivers, dentro de Windows:
- Clic derecho en escritorio → Resolución de pantalla
- Seleccionar la resolución deseada (ahora debería permitir resoluciones altas)

NOTA: con SPICE + QXL la resolución se ajusta automaticamente al redimensionar
la ventana de virt-manager.

---

# Alternativa: usando la interfaz gráfica (virt-manager)

## Paso 1: Abrir virt-manager

```bash
sudo virt-manager
```

## Paso 2: Cambiar modelo de video a QXL

1. Seleccionar la VM → clic en "Abrir"
2. Menú superior: Ver → Detalles
3. En el panel izquierdo seleccionar **Video**
4. Cambiar "Modelo" de `vga` o `cirrus` a **QXL**
5. Clic en "Aplicar"

## Paso 3: Cambiar display a SPICE

1. En el panel izquierdo seleccionar **Pantalla** (Display)
2. Cambiar "Tipo" a **Spice server**
3. Dirección: localhost
4. Puerto: Automático
5. Clic en "Aplicar"

## Paso 4: Agregar la ISO de virtio-win como CD

1. Descargar la ISO primero:
```bash
wget -O /tmp/virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```
2. En virt-manager, panel izquierdo → seleccionar **IDE CDROM** (o agregar hardware → Storage → CDROM)
3. Clic en "Conectar"
4. Buscar y seleccionar `/tmp/virtio-win.iso`
5. Clic en "Aplicar"

## Paso 5: Iniciar la VM e instalar drivers

1. Clic en el boton "Play" (▶) para iniciar la VM
2. Dentro de la VM abrir el CD (unidad D: o E:)

### Windows 10/11:
3. Ejecutar `virtio-win-gt-x64.msi` o `virtio-win-guest-tools.exe`
4. Seguir el asistente de instalación
5. Reiniciar la VM

### Windows Server 2012 R2 u otros Windows antiguos:
El instalador `virtio-win-guest-tools.exe` no es compatible (requiere Windows 10+).
Hay que instalar los drivers manualmente desde el Administrador de dispositivos:

3. Abrir **Administrador de dispositivos** (clic derecho en "Equipo" → Administrar → Administrador de dispositivos)
4. Buscar dispositivos con signo de exclamación amarillo (drivers faltantes)
5. Para cada dispositivo sin driver:
   - Clic derecho → "Actualizar controlador"
   - "Buscar software de controlador en el equipo"
   - Seleccionar la unidad del CD de virtio-win (ej: D:\)
   - Marcar "Incluir subcarpetas"
   - Windows encontrara automaticamente el driver correcto
6. Repetir para el adaptador de pantalla (video QXL) si aparece con exclamacion
7. Reiniciar la VM

## Paso 6: Ajustar resolución

Dentro de Windows:
- Clic derecho en escritorio → Resolución de pantalla
- Seleccionar la resolución deseada

Con SPICE + QXL la resolución se ajusta automaticamente al redimensionar
la ventana de virt-manager. También se puede ir a Ver → Escalar pantalla
para ajustar el modo de visualización.
