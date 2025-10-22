# para encontrar paletas de colores para tus proyectos de diseño:

## Generadores y herramientas online

### Sitios especializados en paletas:
- **Coolors.co** — https://coolors.co (generador muy popular, exporta en varios formatos)
- **Adobe Color** — https://color.adobe.com (integración con productos Adobe)
- **Paletton** — https://paletton.com (teoría del color avanzada)
- **Color Hunt** — https://colorhunt.co (paletas curadas por la comunidad)
- **Flat UI Colors** — https://flatuicolors.com (paletas para interfaces)

### Herramientas de análisis:
- **Khroma** — http://khroma.co (usa AI para generar paletas basadas en tus preferencias)
- **Muzli Colors** — https://colors.muz.li (paletas trending y populares)
- **Colormind** — http://colormind.io (AI que genera paletas)

## Paletas desde imágenes

- **ImageColorPicker** — https://imagecolorpicker.com
- **Color Palette Generator** — https://www.canva.com/colors/color-palette-generator/
- **Adobe Color** (extractor de imágenes) — https://color.adobe.com/create/image

## Para Inkscape específicamente

### Instalación de paletas en Inkscape:

````bash
# Directorio de paletas de usuario en Inkscape
mkdir -p ~/.config/inkscape/palettes

# Descargar paletas GPL (GIMP Palette format)
# Inkscape lee archivos .gpl
````

### Sitios con paletas GPL:
- **GIMP Palettes** — https://github.com/KDE/krita/tree/master/krita/data/palettes
- **Material Design Palettes** — https://github.com/KDE/krita-free-palettes
- **Lospec** — https://lospec.com/palette-list (paletas para pixel art, muchas en GPL)

## Paletas por categorías

### Branding y corporativo:
- **Brand Colors** — https://brandcolors.net (colores de marcas famosas)
- **UI Colors** — https://uicolors.app (paletas para interfaces)

### Naturales y fotografía:
- **Natural Color Palettes** — https://www.design-seeds.com
- **Earth Tones** — https://earthtones.app

### Retro y vintage:
- **LOL Colors** — https://www.webdesignrankings.com/resources/lolcolors/
- **Vintage Color Palettes** — https://color.romanuke.com

## Comandos útiles para gestionar colores

````bash
# Instalar herramientas de color en terminal
sudo apt install imagemagick colorpicker

# Extraer paleta dominante de una imagen con ImageMagick
convert imagen.jpg -colors 5 -depth 8 +dither -format "%c" histogram:info:
````

**Tip**: Muchas de estas herramientas permiten exportar paletas en formato `.gpl` que puedes importar directamente en Inkscape desde `Objeto > Relleno y trazo > Paletas`.