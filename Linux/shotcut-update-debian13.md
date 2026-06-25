# Actualizar Shotcut en Debian 13 (trixie)

## Situación

| Repo | Versión disponible |
|---|---|
| `trixie` (estable) | 25.03.29 |
| `sid` (unstable) | 26.4.30 |

La versión 26.4.30 requiere dependencias (`libmlt7 >= 7.38`, `libqt6 >= 6.10`) que **no existen en trixie**, solo en sid. Mezclar trixie+sid para satisfacerlas es arriesgado. La solución limpia es el **AppImage oficial**: autocontenido, sin tocar el sistema.

---

## Instalación con AppImage

### 1. Limpiar instalación anterior

```bash
sudo apt remove --purge shotcut
```

### 2. Descargar el AppImage oficial

Ir a https://www.shotcut.org/download/ y bajar el archivo `shotcut-linux-x86_64-240430.AppImage`, o directamente:

```bash
wget -P ~/Apps https://github.com/mltframework/shotcut/releases/download/v26.4.30/shotcut-linux-x86_64-26.4.30.AppImage
```

### 3. Instalar dependencia requerida por AppImage

```bash
sudo apt install libfuse2
```

### 4. Dar permisos y ejecutar

```bash
chmod +x ~/Apps/shotcut-linux-x86_64-26.4.30.AppImage
~/Apps/shotcut-linux-x86_64-26.4.30.AppImage
```

### 5. Integrar al menú de aplicaciones (opcional)

Primero extraer el icono del propio AppImage:

```bash
cd ~/Apps
./shotcut-linux-x86_64-26.4.30.AppImage --appimage-extract usr/bin/share/icons/hicolor/128x128/apps/org.shotcut.Shotcut.png
mv squashfs-root/usr/bin/share/icons/hicolor/128x128/apps/org.shotcut.Shotcut.png ~/Apps/shotcut.png
rm -rf squashfs-root
```

Luego crear el acceso directo apuntando al icono extraído:

```bash
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/shotcut.desktop << 'EOF'
[Desktop Entry]
Name=Shotcut
Exec=/home/cesar/Apps/shotcut-linux-x86_64-26.4.30.AppImage
Icon=/home/cesar/Apps/shotcut.png
Type=Application
Categories=AudioVideo;Video;
EOF
update-desktop-database ~/.local/share/applications
```

> No usar `Icon=shotcut` — ese nombre busca un icono instalado por apt que ya no existe.

---

## Actualizar en el futuro

Descargar el nuevo AppImage, reemplazar el archivo anterior y actualizar la ruta en el `.desktop` si cambia el nombre.

---

## Por qué no funciona apt pinning en este caso

El intento de instalar desde sid falla porque shotcut 26.x necesita versiones de `libmlt7` y `libqt6` que tampoco están en trixie:

```
shotcut : Depends: libmlt++7 (>= 7.38.0) but 7.30.0 is available
          Depends: libqt6core6t64 (>= 6.10.2) but 6.8.2 is available
```

Arrastrar esas libs desde sid implicaría actualizar Qt6 completo y otras dependencias del sistema — demasiado riesgo para una sola aplicación.
