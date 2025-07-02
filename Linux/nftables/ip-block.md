# Bloquear IPs que hagan más de 10 conexiones por minuto
nft add rule ip filter input counter value gt 10 action drop

# Bloquear IPs que hagan escaneos de puertos
nft add rule ip filter input ip protocol tcp dport range 1-1024 action drop

# Bloquear IPs de un país específico
nft add rule ip filter input source address 1.1.1.1/24 action drop

# Bloquear IPs que envíen paquetes con contenido sospechoso
nft add rule ip filter input content match { pattern "malware_string" ; } action drop