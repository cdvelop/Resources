# Desinstalar OpenCode (Linux, Debian)

Hay **dos instalaciones independientes** de OpenCode:

| Qué | Dónde | Cómo se quita |
|---|---|---|
| App de escritorio (.deb, paquete `opencode`) | `/opt/OpenCode`, `/usr/bin/ai.opencode.desktop`, `/etc/apparmor.d/ai.opencode.desktop`, lanzadores `opencode-desktop.desktop` y `ai.opencode.desktop.desktop` | `apt` (sección 2) |
| CLI | `~/.opencode/bin/opencode` | borrar `~/.opencode` (sección 3) |

Caso verificado (2026-10-14): paquete `opencode 1.18.35` + CLI en `~/.opencode`.

---

## 1. Comprobar qué hay

```bash
dpkg -l | grep -i opencode
which -a opencode
ls ~/.opencode/bin
```

## 2. Quitar la app de escritorio

La tienda de aplicaciones puede fallar sin mostrar la causa. Hacerlo en
terminal da el error real:

```bash
sudo apt remove opencode        # conserva configuración del sistema
sudo apt purge opencode         # también la borra
```

Simulación sin root (para ver qué haría):

```bash
apt-get -s remove opencode
```

El script de desinstalación (`/var/lib/dpkg/info/opencode.postrm`) hace tres
cosas: quita la alternativa `ai.opencode.desktop` con `update-alternatives`,
descarga el perfil AppArmor de `/etc/apparmor.d/ai.opencode.desktop` y lo borra.
Si falla, el mensaje de `apt` indicará cuál de los tres.

### Si `apt remove` también falla

Primero leer el error. Opciones, de menos a más drástica:

```bash
sudo dpkg --configure -a          # terminar instalaciones a medias
sudo apt -f install               # reparar dependencias rotas
sudo dpkg --remove --force-remove-reinstreq opencode
```

Último recurso (salta el script de desinstalación; limpiar a mano después):

```bash
sudo dpkg --purge --force-all opencode
sudo update-alternatives --remove ai.opencode.desktop /opt/OpenCode/ai.opencode.desktop
sudo rm -f /etc/apparmor.d/ai.opencode.desktop
```

## 3. Quitar la CLI

```bash
rm -rf ~/.opencode
```

## 4. Datos del usuario (NO se borran solos)

```
~/.local/share/opencode/    # opencode.db con todas las sesiones
~/.config/opencode/         # configuración
~/.cache/opencode/          # catálogo de modelos
```

Si quieres poder recuperar sesiones, no los borres (ver
[recuperar-ultima-sesion.md](recuperar-ultima-sesion.md)). Para limpiar todo:

```bash
rm -rf ~/.local/share/opencode ~/.config/opencode ~/.cache/opencode
```
