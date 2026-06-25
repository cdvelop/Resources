# Mantenimiento del Sistema — Debian 13

Guía de limpieza periódica. Ejecutar cada 1-2 meses o cuando el disco supere el 85%.

---

## 1. APT — Paquetes y dependencias

```bash
# Elimina paquetes descargados (.deb) que ya fueron instalados
sudo apt clean

# Elimina dependencias que ya no son necesarias
sudo apt autoremove -y
```

> Recupera: 5–25 GB dependiendo del tiempo desde la última limpieza.

---

## 2. Logs del sistema

```bash
# Mantiene solo los últimos 100 MB de logs de journald
sudo journalctl --vacuum-size=100M

# Elimina logs rotados comprimidos y backups
sudo find /var/log -name "*.gz" -delete
sudo find /var/log -name "*.1" -delete
```

> Recupera: 0.5–2 GB.

---

## 3. Docker

```bash
# Elimina contenedores detenidos, redes y capas huérfanas
docker system prune -f

# Elimina volúmenes sin usar (¡revisar antes!)
docker volume prune -f

# Ver qué imágenes existen y cuánto ocupan
docker image ls -a
docker system df

# Eliminar imagen específica (primero remover su contenedor si existe)
docker rm <nombre_contenedor>
docker rmi <imagen>:<tag>
```

> Revisar siempre qué contenedores usan cada imagen antes de borrar.
> La DB `mjosefa` vive en el contenedor `pg14-dev` (imagen `postgres-replica:14`).

---

## 4. Cache de usuario (~/.cache)

```bash
# Ver qué ocupa más
du -sh ~/.cache/*/ | sort -rh | head -20

# Caches de Go — se regeneran automáticamente
rm -rf ~/.cache/goimports
rm -rf ~/.cache/go-build
rm -rf ~/.cache/tinygo

# Caches de testing/browsers automáticos — se re-descargan solos
rm -rf ~/.cache/rod
rm -rf ~/.cache/ms-playwright-go
```

> **No borrar:** `~/.cache/BraveSoftware`, `~/.cache/google-chrome`, `~/.cache/Google`
> (contienen sesiones y datos de navegadores en uso).

---

## 5. Revisar estado final

```bash
# Espacio en disco
df -h /

# Resumen rápido de los directorios más pesados
du -sh /var/cache/apt/ /var/log/ ~/.cache/
```

---

## Script todo-en-uno (sin sudo)

```bash
docker system prune -f && \
docker volume prune -f && \
rm -rf ~/.cache/goimports ~/.cache/go-build ~/.cache/tinygo ~/.cache/rod ~/.cache/ms-playwright-go && \
echo "Listo. Ahora corre manualmente: sudo apt clean && sudo apt autoremove -y"
```

> Los comandos con `sudo` hay que correrlos en terminal interactiva por separado.

---

## Referencia de resultados (junio 2026)

| Fuente | Antes | Después |
|---|---|---|
| Disco total usado | 389 GB (88%) | 353 GB (80%) |
| APT cache | 22 GB | 94 MB |
| Logs | 1.5 GB | 88 MB |
| ~/.cache | 21 GB | 7.3 GB |
| **Total recuperado** | | **~36 GB** |
