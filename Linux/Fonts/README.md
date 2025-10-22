# comando para instalar fuentes microsoft debian 
```bash
sudo apt install ttf-mscorefonts-installer
```

# donde se guardan las fuentes del sistema en debian 12?

Las fuentes en Debian 12 se guardan principalmente en estas rutas:

- System-wide:
  - /usr/share/fonts
  - /usr/local/share/fonts
  - /usr/share/X11/fonts (legacy/compatibilidad)
  - Subdirectorios comunes: /usr/share/fonts/truetype, /usr/share/fonts/opentype, /usr/share/fonts/type1

- Por usuario:
  - ~/.local/share/fonts
  - ~/.fonts (obsoleto pero aún usado por algunos programas)

- Cachés y herramientas:
  - Caché de fontconfig (por usuario): ~/.cache/fontconfig
  - Caché del sistema (puede existir): /var/cache/fontconfig

## Comandos útiles:

### ejecutar nautilus en modo root para gestionar fuentes del sistema
```bash
nautilus admin:///usr/share/fonts
```


### listar ubicaciones
```bash
ls -la /usr/share/fonts /usr/local/share/fonts ~/.local/share/fonts ~/.fonts
```
### listar todas las fuentes reconocidas por fontconfig
```bash
fc-list
```
```bash
fc-list
```
### forzar regeneración de caché de fuentes
```bash
fc-cache -fv
```

Si instalas nuevas fuentes ponlas en ~/.local/share/fonts (usuario) o /usr/local/share/fonts (sistema) y ejecuta fc-cache -fv.

## Fuentes recomendadas y cómo añadirlas

Si quieres mejorar las fuentes para diseñar con Inkscape, aquí tienes recomendaciones, fuentes y métodos de instalación.

- Fuentes recomendadas (versátiles y gratuitas): Inter, Roboto, Noto (multilenguaje), Source Sans / Source Serif, Merriweather, Playfair Display, Montserrat, Poppins, Fira Sans, Lora, Libre Baskerville.
- Repositorios y sitios confiables:
  - Google Fonts — https://fonts.google.com (descarga individual o clona el repo: https://github.com/google/fonts)
  - WhatTheFont — https://www.myfonts.com/WhatTheFont/ (identificación de fuentes por imagen)
  - Font Squirrel — https://www.fontsquirrel.com (libres para uso comercial)
  - Font Library — https://fontlibrary.org
  - DaFont — https://www.dafont.com (revisar licencias antes de uso comercial)

### Instalación rápida en Debian

1) Instalar paquetes de fuentes comunes desde los repositorios APT:

```bash
sudo apt update
sudo apt install fonts-noto fonts-dejavu-core fonts-liberation fonts-roboto fonts-firacode
```

2) Instalar familias desde Google Fonts (descarga manual o clonar GitHub):

```bash
# clonar el repositorio de Google Fonts (ocupa bastante espacio)
git clone https://github.com/google/fonts.git ~/Downloads/google-fonts
# copiar las familias que quieras al directorio de usuario
mkdir -p ~/.local/share/fonts
cp -r ~/Downloads/google-fonts/ofl/Inter ~/.local/share/fonts/
fc-cache -fv
```

3) Instalar archivos TTF/OTF manualmente para el usuario:

```bash
mkdir -p ~/.local/share/fonts
cp /ruta/a/mi-fuente.ttf ~/.local/share/fonts/
fc-cache -fv
```

4) Instalar con GUI (GNOME Font Viewer):

```bash
sudo apt install gnome-font-viewer
# luego abrir el .ttf/.otf y usar el botón "Instalar"
```

5) Fuentes Microsoft (si las necesitas):

```bash
sudo apt install ttf-mscorefonts-installer
fc-cache -fv
```

### Notas

- Después de copiar nuevas fuentes siempre ejecuta `fc-cache -fv` para que las aplicaciones (Inkscape, LibreOffice, etc.) las reconozcan.
- Si prefieres mantener el sistema limpio, instala fuentes en `~/.local/share/fonts` para uso sólo del usuario actual.
- Revisa las licencias antes de usar fuentes en proyectos comerciales.