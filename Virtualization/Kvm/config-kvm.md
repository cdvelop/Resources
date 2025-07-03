# Configurar ruta personalizada para imágenes de KVM (libvirt) en Debian 12

## Cambiar la ruta por defecto en libvirt

1. Edita el archivo de configuración de libvirt:
   ```bash
   sudo nano /etc/libvirt/qemu.conf

   # o con vsc como super usuario
   sudo code --no-sandbox --user-data-dir=/tmp/vsc-root /etc/libvirt/qemu.conf
   ```
2. Busca la línea:
   ```
   # default_pool_path = "/var/lib/libvirt/images"
   ```
   Si la encuentras, descoméntala y cámbiala por tu ruta deseada:
   ```
   default_pool_path = "/home/YOU_USER_NAME/Dev/VM/QEMU"
   ```
   **Si no existe la línea, agrégala al final del archivo:**
   ```
   default_pool_path = "/home/YOU_USER_NAME/Dev/VM/QEMU"
   ```
3. (Opcional) Si tienes imágenes existentes en la ruta por defecto `/var/lib/libvirt/images/`, puedes moverlas al nuevo directorio antes de reiniciar:
   ```bash
   sudo mv /var/lib/libvirt/images/* /home/$USER/Dev/VM/QEMU/
   ```
   > Nota: Este paso solo es necesario si existen archivos en `/var/lib/libvirt/images/`. Si la carpeta está vacía o tus imágenes ya están en la nueva ubicación, puedes omitirlo.
4. Guarda y cierra el archivo.
5. Reinicia el servicio de libvirt:
   ```bash
   sudo systemctl restart libvirtd
   ```

## Usar una carpeta personalizada como pool de almacenamiento
Si ya tienes imágenes en `/home/$USER/Dev/VM/QEMU`, puedes crear un pool de almacenamiento en libvirt que apunte a esa carpeta.

### Crear un nuevo pool de almacenamiento con virsh

1. Crea el pool (tipo dir):
   ```bash
   virsh pool-define-as VM-QEMU dir --target /home/$USER/Dev/VM/QEMU
   ```
2. Inicia el pool:
   ```bash
   virsh pool-start VM-QEMU
   ```
3. Haz que el pool se inicie automáticamente:
   ```bash
   virsh pool-autostart VM-QEMU
   ```
4. (Opcional) Refresca el pool para que detecte las imágenes existentes:
   ```bash
   virsh pool-refresh VM-QEMU
   ```

### Usar virt-manager
- Ve a **Editar > Detalles de conexión > Pools de almacenamiento**.
- Crea uno nuevo apuntando a `/home/$USER/Dev/VM/QEMU`.
- Actívalo y márcalo para autoinicio si lo deseas.

Ahora podrás crear y usar máquinas virtuales con imágenes en esa carpeta personalizada.
