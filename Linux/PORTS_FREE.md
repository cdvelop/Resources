En Debian 13, primero identifica qué proceso está escuchando en el puerto 8080:

```bash
sudo ss -ltnp 'sport = :8080'
```

La salida suele mostrar el nombre del proceso y su `pid`. Intenta detenerlo de forma normal:

```bash
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process                               
LISTEN   0        4096                   *:8080                *:*      users:(("server",pid=507394,fd=7))
```

- Si es un servicio, averigua su nombre y ejecuta `sudo systemctl stop nombre-del-servicio`.
- Si es un contenedor, busca cuál lo publica con `docker ps --filter publish=8080` y detenlo con `docker stop ID_DEL_CONTENEDOR`.
- Si no es un servicio, envíale una señal de cierre usando el PID que encontraste: `sudo kill PID`.

Comprueba que el puerto quedó libre repitiendo el comando `ss`. Evita `kill -9` salvo como último recurso: no permite que el proceso cierre limpiamente.



El puerto 8080 lo está usando el proceso `server` con PID `507394`. Puedes detenerlo de forma segura con:

```bash
sudo kill -TERM 507394
```

Comprueba si se liberó:

```bash
sudo ss -ltnp 'sport = :8080'
```

Si prefieres averiguar primero qué servidor es y cómo se inició:

```bash
ps -fp 507394
sudo readlink -f /proc/507394/exe
```

Si vuelve a aparecer, probablemente lo reinicia un servicio o supervisor; en ese caso conviene detenerlo desde ahí en vez de matar el proceso.