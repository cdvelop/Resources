

# Virtualizar en Debian 12 - Instalación de QEMU/KVM

> Créditos: [Juan J.J. - Linuxeroerrante](https://www.youtube.com/@Linuxeroerrante)

[![Ver video en YouTube](https://img.youtube.com/vi/N9AtdJjcE4A/0.jpg)](https://www.youtube.com/watch?v=N9AtdJjcE4A)

---

## Pasos a seguir

### 1. Verificar soporte de virtualización en el procesador
Para Intel: `vmx` &nbsp;&nbsp;|&nbsp;&nbsp; Para AMD: `svm`
```bash
grep -E --color 'vmx|svm' /proc/cpuinfo
```

### 2. Comprobar si la virtualización está activada
```bash
egrep -c 'vmx|svm' /proc/cpuinfo
```

### 3. Instalar los paquetes necesarios
```bash
sudo apt install qemu-kvm libvirt-clients libvirt-daemon libvirt-daemon-system bridge-utils virtinst virt-manager
```

### 4. Verificar y activar el servicio de libvirt
```bash
sudo systemctl status libvirtd.service
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

### 5. Enumerar y activar redes para máquinas virtuales
```bash
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default
```

### 6. Añadir tu usuario a los grupos necesarios
```bash
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
```

### 7. Reiniciar el sistema
```bash
sudo reboot
```