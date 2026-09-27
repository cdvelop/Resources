# Instalar LM Studio en Debian 13 (y arreglar instalaciones duplicadas)

## Síntoma

En el dashboard de aplicaciones de GNOME aparecen **dos** entradas de LM Studio:

- Una con icono.
- Otra sin icono (genérica).

Ninguna se puede "desinstalar" desde el dashboard porque son de origen distinto
(una es un paquete `.deb`, la otra es un AppImage integrado por AppImageLauncher).

## Diagnóstico

Comandos usados para identificar el origen de cada entrada:

```bash
# Entradas .desktop relacionadas con LM Studio
find ~/.local/share/applications /usr/share/applications -iname '*lm*studio*'

# Paquete instalado vía dpkg/apt
dpkg -l | grep -i lm-studio

# Binario resuelto por el sistema
which lm-studio
```

### Instalación 1 — paquete `.deb` (la que hay que conservar)

- Paquete: `lm-studio 0.4.25+1` (`dpkg -l`).
- Binario: `/usr/bin/lm-studio` → `/opt/LM-Studio/lm-studio` (propiedad de `root`,
  instalado correctamente por `dpkg`).
- Entrada de escritorio: `/usr/share/applications/ai.elementlabs.lmstudio.desktop`.
- Iconos instalados en tamaños estándar del tema `hicolor`:
  `/usr/share/icons/hicolor/{16,24,32,48,64,128,256,512}x{misma}/apps/lm-studio.png`.
- **Esta es la que muestra icono** en el dashboard, porque sus iconos están en
  carpetas de tamaño válido del tema de iconos.

### Instalación 2 — AppImage vieja integrada con AppImageLauncher (la que sobra)

- Archivo: `~/Applications/LM-Studio-0.4.14-4-x64_281ca60f9488916d8fbc5621134d0a05.AppImage`
  (versión antigua, 0.4.14+4).
- Entrada de escritorio generada por AppImageLauncher:
  `~/.local/share/applications/appimagekit_72769549ef1babeea1bf64a9aa22181a-LM-Studio.desktop`.
- Su icono fue instalado en `~/.local/share/icons/hicolor/0x0/apps/...png`.
  **`0x0` no es un tamaño válido** del tema de iconos hicolor, así que GNOME no lo
  resuelve y muestra el icono genérico → **esta es la que aparece sin icono**.

## Solución: eliminar la instalación AppImage duplicada

La entrada `.desktop` de AppImageLauncher trae su propia acción de borrado, que
limpia a la vez el `.desktop`, el icono cacheado y (si se confirma) el `.AppImage`:

```
Clic derecho sobre el icono sin nombre en el dashboard → "Delete this AppImage" / "Eliminar AppImage del sistema"
```

Alternativa manual (si se prefiere no usar la acción del launcher, o si ya se
borró el `.desktop` a mano):

```bash
rm ~/.local/share/applications/appimagekit_72769549ef1babeea1bf64a9aa22181a-LM-Studio.desktop
rm ~/.local/share/icons/hicolor/0x0/apps/appimagekit_72769549ef1babeea1bf64a9aa22181a_lm-studio.png
rm ~/Applications/LM-Studio-0.4.14-4-x64_281ca60f9488916d8fbc5621134d0a05.AppImage

update-desktop-database ~/.local/share/applications
gtk-update-icon-cache ~/.local/share/icons/hicolor 2>/dev/null
```

Si el dashboard de GNOME sigue mostrando la entrada vieja en caché, reiniciar
GNOME Shell (`Alt+F2` → `r` → `Enter` en Xorg, o cerrar sesión en Wayland).

> Nota: `~/.config/LM-Studio` (config, crashpad, logs) pertenece a la app en
> general, no a una instalación en particular — no hace falta tocarlo.

## Verificar que solo queda una instalación

```bash
dpkg -l | grep -i lm-studio                 # debe listar el paquete .deb
which lm-studio                              # /usr/bin/lm-studio
find ~/.local/share/applications /usr/share/applications -iname '*lm*studio*'
# debe devolver solo /usr/share/applications/ai.elementlabs.lmstudio.desktop
```

## Cómo instalar/actualizar sin volver a duplicar

- Instalar siempre el `.deb` con `apt install ./LM-Studio-X.Y.Z-N-x64.deb`
  (o `sudo dpkg -i ...`). Esto **actualiza** el paquete `lm-studio` existente en
  lugar de crear una instalación paralela — por eso `dpkg -l` ya mostraba
  `0.4.25+1` aunque el `.deb` descargado en `~/Downloads` seguía ahí.
- Evitar usar el AppImage suelto en paralelo al `.deb`. Si se prueba una versión
  AppImage puntual, no dejar que AppImageLauncher la "integre" al dashboard (o
  desintegrarla apenas se termine de probar) para no volver a duplicar entradas.
- El `.deb` descargado en `~/Downloads/LM-Studio-*.deb` se puede borrar tras
  instalar; `apt`/`dpkg` no lo necesita una vez aplicado.
