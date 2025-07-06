# NFTABLES
es un firewall reemplazo de iptables mas nuevo y mejor performance

## Instalación y activación de nftables en un solo comando
```bash
sudo bash -c 'apt update && apt install -y nftables && systemctl enable nftables && systemctl start nftables'
```
Esto pedirá la contraseña solo una vez y dejará nftables instalado y activo.

3. Verifica el estado de nftables:
```bash
sudo systemctl status nftables
```

# 4. Para ver las reglas activas (por defecto puede estar vacío):
```bash
sudo nft list ruleset
```

### ¿Qué significa la configuración por defecto?

Al instalar nftables, la configuración inicial suele ser:

```nft
table inet filter {
    chain input {
        type filter hook input priority filter; policy accept;
    }
    chain forward {
        type filter hook forward priority filter; policy accept;
    }
    chain output {
        type filter hook output priority filter; policy accept;
    }
}
```

Esto significa que todo el tráfico entrante, saliente y reenviado está permitido (policy accept). No hay restricciones.

---

