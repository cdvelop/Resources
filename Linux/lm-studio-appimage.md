# LM Studio — Instalación con AppImage en Debian

## Por qué AppImage y no el instalador oficial

El instalador oficial (`install.sh`) requiere `ldconfig` y permisos de root para registrar
bibliotecas del sistema. El AppImage es autocontenido: incluye todo lo que necesita y no
modifica el sistema.

---

## Instalación completa (un solo comando)

Copia y pega esto en la terminal. Crea el ejecutable, el ícono en el menú de aplicaciones
y un acceso directo en `~/.local/bin/lmstudio`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AppImage/AppImageKit/master/AppRun) 2>/dev/null; \
APP=~/Downloads/LM-Studio-0.4.14-4-x64.AppImage && \
chmod +x "$APP" && \
mkdir -p ~/.local/bin ~/.local/share/applications ~/.local/share/icons && \
cp "$APP" ~/.local/bin/lmstudio && \
"$APP" --appimage-extract-and-run squashfs-root/usr/share/icons/hicolor/512x512/apps/*.png 2>/dev/null \
  || "$APP" --appimage-extract squashfs-root 2>/dev/null && \
ICON=$(find squashfs-root -name "*.png" | grep -i "512\|256\|icon" | head -1) && \
[ -n "$ICON" ] && cp "$ICON" ~/.local/share/icons/lmstudio.png && rm -rf squashfs-root; \
cat > ~/.local/share/applications/lmstudio.desktop << 'EOF'
[Desktop Entry]
Name=LM Studio
Comment=Run local AI models
Exec=/home/cesar/.local/bin/lmstudio
Icon=/home/cesar/.local/share/icons/lmstudio.png
Type=Application
Categories=Utility;Science;
Terminal=false
EOF
update-desktop-database ~/.local/share/applications 2>/dev/null; \
echo "✓ LM Studio instalado. Ejecuta: lmstudio"
```

---

## Script de instalación (más fácil de reutilizar)

Guarda esto como `~/Dev/Resources/Linux/install-lmstudio.sh` y ejecútalo con `bash install-lmstudio.sh`:

```bash
#!/bin/bash
# Uso: bash install-lmstudio.sh [ruta-al-appimage]
# Si no se pasa ruta, busca en ~/Downloads automáticamente

set -e

APP="${1:-$(ls ~/Downloads/LM-Studio-*.AppImage 2>/dev/null | sort -V | tail -1)}"

if [ -z "$APP" ] || [ ! -f "$APP" ]; then
    echo "ERROR: No se encontró el AppImage. Descárgalo de https://lmstudio.ai"
    echo "Uso: bash install-lmstudio.sh ~/Downloads/LM-Studio-0.4.14-x64.AppImage"
    exit 1
fi

echo "→ Instalando desde: $APP"

chmod +x "$APP"
mkdir -p ~/.local/bin ~/.local/share/applications ~/.local/share/icons

cp "$APP" ~/.local/bin/lmstudio

# Extraer ícono del AppImage
"$APP" --appimage-extract squashfs-root 2>/dev/null || true
ICON=$(find squashfs-root -name "*.png" 2>/dev/null | grep -iE "512|256|icon" | head -1)
if [ -n "$ICON" ]; then
    cp "$ICON" ~/.local/share/icons/lmstudio.png
fi
rm -rf squashfs-root

# Crear entrada en el menú de aplicaciones
cat > ~/.local/share/applications/lmstudio.desktop << EOF
[Desktop Entry]
Name=LM Studio
Comment=Run local AI models
Exec=$HOME/.local/bin/lmstudio
Icon=$HOME/.local/share/icons/lmstudio.png
Type=Application
Categories=Utility;Science;
Terminal=false
EOF

update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo ""
echo "✓ LM Studio instalado correctamente."
echo "  - Menú de apps: busca 'LM Studio'"
echo "  - Terminal:     lmstudio"
```

### Cómo usarlo

```bash
bash /home/cesar/Dev/Resources/Linux/install-lmstudio.sh
```

O pasándole la ruta explícita:

```bash
bash /home/cesar/Dev/Resources/Linux/install-lmstudio.sh ~/Downloads/LM-Studio-0.4.14-4-x64.AppImage
```

---

## Método más automático: AppImageLauncher

[AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher) es una herramienta que
**detecta automáticamente cualquier AppImage que abras** y te ofrece integrarlo al sistema
con un clic — sin comandos.

### Instalar AppImageLauncher en Debian 13

```bash
# El nombre del .deb incluye un hash de build, hay que buscarlo dinámicamente
URL=$(curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/tags/continuous \
  | python3 -c "import json,sys; assets=[a['browser_download_url'] for a in json.load(sys.stdin)['assets'] if 'amd64.deb' in a['name']]; print(assets[0])") \
&& wget "$URL" -O /tmp/appimagelauncher.deb \
&& sudo dpkg -i /tmp/appimagelauncher.deb \
&& sudo apt install -f
```

### Cómo funciona después de instalarlo

1. Doble clic en cualquier `.AppImage` desde el explorador de archivos
2. AppImageLauncher pregunta: **"¿Integrar al sistema?"**
3. Clic en **Sí** → crea el ícono en el menú automáticamente
4. Listo — sin comandos

> Esta es la opción más cómoda si frecuentemente usas aplicaciones AppImage.

---

## Desinstalar LM Studio

```bash
rm ~/.local/bin/lmstudio
rm ~/.local/share/applications/lmstudio.desktop
rm ~/.local/share/icons/lmstudio.png
update-desktop-database ~/.local/share/applications
```
