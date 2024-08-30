#!/bin/bash

# Nombre de la máquina virtual
VM_NAME="debian12"

# RAM asignada
RAM="4096"

# CPU asignadas
CPU_COUNT="3"

# Nombre del archivo de disco duro virtual
VHD_FILE="${VM_NAME}.vdi"

# Dirección IP fija
IP_ADDRESS="192.168.0.100"

# Máscara de subred
NETMASK="255.255.255.0"

# Puerta de enlace
GATEWAY="192.168.0.1"

# Ruta al archivo ISO de Debian 12
ISO_FILE="/path/to/debian-12.iso"

# Comprueba si VirtualBox está instalado
if ! command -v VBoxManage &> /dev/null; then
  echo "Error: VirtualBox no está instalado. Instala VirtualBox antes de ejecutar este script."
  exit 1
fi

# Crea la máquina virtual
vboxmanage createvm --name "$VM_NAME" --ostype Debian_64 --register

# Configura la memoria RAM
vboxmanage modifyvm "$VM_NAME" --memory "$RAM"

# Configura los procesadores
vboxmanage modifyvm "$VM_NAME" --cpus "$CPU_COUNT"

# Crea el disco duro virtual
vboxmanage createhd --filename "$VHD_FILE" --size 20480 --format VDI

# Conecta el disco duro virtual a la máquina virtual
vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IDE

vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VHD_FILE"

# Conecta la imagen ISO de Debian 12
vboxmanage storagectl "$VM_NAME" --name "IDE Controller" --add ide --controller PIIX4

vboxmanage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_FILE"

# Configura la red
vboxmanage modifyvm "$VM_NAME" --nic1 nat
vboxmanage modifyvm "$VM_NAME" --nic2 bridged --bridgedif "eth0"
vboxmanage modifyvm "$VM_NAME" --macaddress2 "080027E1E000"

# Configura la IP fija
vboxmanage modifyvm "$VM_NAME" --natpf1 "guestssh,tcp,,22,2222"
vboxmanage modifyvm "$VM_NAME" --natpf1 "guestweb,tcp,,80,8080"

# Inicia la máquina virtual
vboxmanage startvm "$VM_NAME" --type headless

# Espera a que la máquina virtual esté en ejecución
while ! vboxmanage showvminfo "$VM_NAME" | grep -q "State: Running"; do
  sleep 1
done

# Configura la red dentro de la máquina virtual
echo "Configurando la red dentro de la máquina virtual..."
echo "Asegúrate de que la conexión a Internet funciona y ejecuta los siguientes comandos en la máquina virtual:"
echo "sudo apt update"
echo "sudo apt install net-tools"
echo "sudo ifconfig eth0 $IP_ADDRESS netmask $NETMASK"
echo "sudo route add default gw $GATEWAY"
echo "sudo systemctl restart networking"

echo "La máquina virtual Debian 12 ha sido creada con éxito."
echo "El nombre de la máquina virtual es: $VM_NAME"
echo "La dirección IP asignada es: $IP_ADDRESS"