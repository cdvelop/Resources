## Ejemplo Aplicar reglas básicas de nftables automáticamente

#### Ejemplo 1: Reglas para laptop de desarrollo y uso general (SMB, SSH, DLNA, web local)

```bash
sudo bash -c '
cat > /etc/nftables.conf <<EOF
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;
        ct state established,related accept
        iif "lo" accept
        tcp dport 22 accept      # SSH
        tcp dport 80 accept      # HTTP local
        tcp dport 443 accept     # HTTPS local
        tcp dport 445 accept     # SMB moderno (SMB sobre TCP)
        udp dport 1900 accept    # DLNA SSDP (descubrimiento UPnP)
        tcp dport 8200 accept    # MiniDLNA (puedes agregar otros puertos si tu servidor DLNA usa diferentes)
    }
    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }
    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
EOF
nft -f /etc/nftables.conf
'
```
>compatibilidad equipos antiguos (windows)
 tcp dport 139 accept     # SMB sobre NetBIOS 
 udp dport 137 accept     # NetBIOS Name Service(descubrimiento)
 udp dport 138 accept     # NetBIOS Datagram Service (mensajes/anuncios)


---

#### Ejemplo 2: Servidor web típico (solo SSH y HTTPS)

Permite únicamente conexiones SSH (22) y HTTPS (443), además de tráfico local y conexiones ya establecidas:

```bash
sudo bash -c '
cat > /etc/nftables.conf <<EOF
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;
        ct state established,related accept
        iif "lo" accept
        tcp dport 22 accept   # Permite SSH
        tcp dport 443 accept  # Permite HTTPS
    }
    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }
    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
EOF
nft -f /etc/nftables.conf
'
```

---

#### Ejemplo 3: Más permisivo (permite todo el tráfico entrante TCP y UDP, pero bloquea forward)

No recomendado para producción, pero útil para pruebas o entornos controlados:

```bash
sudo bash -c '
cat > /etc/nftables.conf <<EOF
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy accept;
    }
    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }
    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
EOF
nft -f /etc/nftables.conf
'
```

---

> **Nota:** Todos los ejemplos aplican la configuración con `sudo nft -f /etc/nftables.conf`, lo que recarga el firewall inmediatamente. Si editas el archivo manualmente, recuerda ejecutar este comando para que los cambios tengan efecto. Puedes verificar las reglas activas con:
```bash
sudo nft list ruleset
```
