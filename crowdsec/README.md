# crowdsec

CrowdSec es una solución de seguridad de código abierto que protege sistemas y aplicaciones detectando y bloqueando actividades maliciosas. Sus principales características son:

- Análisis de logs en tiempo real para detectar amenazas
- Base de datos colaborativa de amenazas compartida por la comunidad
- Bloqueo automático de IPs maliciosas
- Soporte para múltiples servicios y sistemas operativos
- Fácil integración con firewalls y servicios existentes
- Interfaz web para monitoreo y gestión
- API REST para automatización
- Arquitectura modular y extensible
- Comunidad activa de usuarios y desarrolladores

CrowdSec funciona analizando logs de servicios, detectando patrones de ataque y tomando acciones de mitigación como bloquear IPs. La información de amenazas se comparte entre todos los usuarios de CrowdSec para crear una protección colectiva.

https://github.com/crowdsecurity/crowdsec

# instalación:
https://docs.crowdsec.net/u/getting_started/installation/linux/

```bash
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
sudo apt-get update
sudo apt-get install crowdsec
# según el firewall del servidor se configura el motor de acción ej debian Hetzner tiene iptables
sudo apt install crowdsec-firewall-bouncer-iptables
```

# tutorial:
https://youtu.be/hCxDq942ESU?si=IThtv_NeHzTIIDuY
# curso
https://youtu.be/ED6hR_ROoZo?si=hLPQroq9y2DqEleD


# después de la instalación hay que enrollar el agente
- desde la pagina de administración de crowdsec

# ver scenarios de configuraciones
```bash
sudo cscli decision list
```

# ver lista de decisiones ip de bloqueo
```bash
sudo cscli decisions list
```