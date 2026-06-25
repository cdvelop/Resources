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
