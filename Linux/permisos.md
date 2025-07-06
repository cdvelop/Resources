Si quieres que **cualquier usuario pueda ejecutar los scripts** que están en tu carpeta (por ejemplo `~/Dev/Pkg/Mine/devscripts/`), necesitas:

---

### ✅ 1. **Dar permisos de ejecución para todos**

```bash
chmod -R a+rx ~/Dev/Pkg/Mine/devscripts
```

* `a+rx`: da permisos de **lectura (`r`)** y **ejecución (`x`)** a **todos (a = all)**.
* La ejecución (`x`) es necesaria para:

  * Carpetas: poder entrar a ellas.
  * Archivos: poder ejecutarlos como scripts.

> Esto **no da permisos de escritura a otros usuarios**, lo cual es bueno por seguridad.

---

### ✅ 2. (Opcional) Asegúrate de que los archivos sean scripts ejecutables

Si solo quieres marcar los `.sh` como ejecutables:

```bash
find ~/Dev/Pkg/Mine/devscripts -type f -name "*.sh" -exec chmod a+rx {} \;
```

---

### ✅ 3. (Opcional) Añadir la carpeta al `PATH` para otros usuarios

Si quieres que **todos los usuarios** del sistema puedan ejecutar los scripts desde cualquier parte (como comandos), puedes:

#### Opción A: Crear enlaces simbólicos en `/usr/local/bin`

```bash
sudo ln -s /home/cesar/Dev/Pkg/Mine/devscripts/miscript.sh /usr/local/bin/miscript
```

Haz esto por cada script que quieras hacer accesible globalmente.

#### Opción B: Añadir la carpeta al `PATH` de todos los usuarios

Agrega esta línea a `/etc/profile` (se aplica a todos los shells de login):

```bash
export PATH="$PATH:/home/cesar/Dev/Pkg/Mine/devscripts"
```

O crea un archivo en `/etc/profile.d/devscripts.sh`:

```bash
sudo nano /etc/profile.d/devscripts.sh
```

Y escribe:

```bash
export PATH="$PATH:/home/cesar/Dev/Pkg/Mine/devscripts"
```

Guarda, da permisos:

```bash
sudo chmod +x /etc/profile.d/devscripts.sh
```

Esto hará que cualquier usuario que inicie sesión tenga acceso directo a los scripts desde esa carpeta.

---


