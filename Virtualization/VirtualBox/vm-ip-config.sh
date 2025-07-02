#!/bin/bash

configure_vm_ip() {
    local VM_NAME=$1
    local LAST_OCTET=$2

    # Detectar la interfaz de red física en uso y en estado UP
    local INTERFACE=$(powershell.exe -Command "Get-NetAdapter | Where-Object { \$_.Status -eq 'Up' -and \$_.InterfaceDescription -notlike '*WSL*' -and \$_.InterfaceDescription -notlike '*Virtual*' } | Select-Object -First 1 -ExpandProperty Name")
    echo "Interface: $INTERFACE"

    local SUBNET_MASK=$(ipconfig | grep -A 4 "$INTERFACE" | grep "Subnet Mask" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    echo "Subnet Mask: $SUBNET_MASK"

    # Obtener la dirección IP
    local IP=$(powershell.exe -Command "(Get-NetIPAddress -InterfaceAlias \"$INTERFACE\" -AddressFamily IPv4).IPAddress")

    # Extraer el último octeto de la IP
    local LAST_OCTET_IP="${IP##*.}"

    # Construir la nueva IP
    local NEW_IP="${IP%.*}.$LAST_OCTET"

    # Obtener la dirección MAC de la máquina virtual
    local MAC=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | grep macaddress1 | cut -d'"' -f2)

    echo "MAC: $MAC"
    echo "IP: $IP"
    echo "new ip: $NEW_IP"

    # Configurar el servidor DHCP de VirtualBox
    # VBoxManage dhcpserver remove --network=HostInterfaceNetworking-$INTERFACE
    # VBoxManage dhcpserver add --network=HostInterfaceNetworking-$INTERFACE --server-ip=$IP --lower-ip=$NEW_IP --upper-ip=$NEW_IP --enable
    # VBoxManage dhcpserver add --interface=Ethernet --server-ip=$IP --netmask=$SUBNET_MASK --lower-ip=$NEW_IP --upper-ip=$NEW_IP --enable
    # Configurar la máquina virtual para usar el adaptador de puente
    # VBoxManage modifyvm "$VM_NAME" --nic1 bridged --bridgeadapter1 "$INTERFACE"

    # Asignar la dirección MAC estática a la máquina virtual
    # VBoxManage modifyvm "$VM_NAME" --macaddress1 $MAC

    # echo "Configuración completada. La máquina virtual $VM_NAME debería obtener la IP $NEW_IP al iniciar."
}

# Uso de la función:
# configure_vm_ip "NombreDeLaMaquinaVirtual" "UltimoOctetoDeLaIP"
# Ejemplo: configure_vm_ip "Debian12" "100"
configure_vm_ip "Debian12" "100"