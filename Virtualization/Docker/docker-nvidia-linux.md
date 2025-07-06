Summarized conversation historySummarized conversation historySummarized conversation historyTu sistema detecta correctamente la GPU NVIDIA y los drivers están instalados, pero el runtime `nvidia` no está disponible en Docker. Esto significa que el toolkit de NVIDIA para Docker (nvidia-docker) no está instalado o no está correctamente configurado.

**Solución:**
Debes instalar el NVIDIA Container Toolkit siguiendo la guía oficial:  
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

Pasos rápidos para Ubuntu (Linux):

1. Instala el repositorio:
   ```sh
   sudo apt-get update
   sudo apt-get install -y nvidia-container-toolkit
   ```

2. Reinicia el servicio Docker:
   ```sh
   sudo systemctl restart docker
   ```

3. Verifica que el runtime `nvidia` esté disponible:
   ```sh
   docker info | grep -i nvidia
   ```

¿Quieres que te ayude con los comandos exactos para tu distribución?