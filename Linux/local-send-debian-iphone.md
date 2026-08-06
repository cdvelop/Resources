Enviar archivos o fotos desde un iPhone (iOS) a una laptop con Debian 13 utilizando la red local (LAN/Wi-Fi) es bastante sencillo. Aquí tienes las mejores opciones disponibles, ordenadas de la más fácil y directa a la más avanzada.

---

### Opción 1: Localsend (La más recomendada y multiplataforma)

**LocalSend** es una aplicación de código abierto, gratuita, sin anuncios y muy similar a AirDrop, pero funciona perfectamente entre iOS y Linux (Debian).

1. **En Debian 13:**
* Instálala usando Flatpak (la forma más sencilla):
```bash
flatpak install flathub org.localsend.localsend_app

```


* O descárgate el paquete `.deb` desde su [sitio web oficial](https://localsend.org/).
* Abre la aplicación en tu laptop.


2. **En tu iPhone:**
* Descarga **LocalSend** desde la App Store.
* Abre la app (asegúrate de que tanto tu iPhone como tu laptop estén conectados a la misma red Wi-Fi).


3. **Para enviar:**
* Selecciona la foto o archivo en tu iPhone, compártelo usando la app de LocalSend, elige tu laptop Debian en la lista de dispositivos detectados y ¡listo!



---

### Opción 2: Snapdrop.net o LocalDrop (Sin instalar nada en el iPhone)

Si no quieres instalar ninguna aplicación en el teléfono, puedes usar herramientas web que funcionan directamente en el navegador del iPhone a través de la red local.

1. **En Debian 13:**
* Abre tu navegador web (Firefox, Chrome, etc.) y entra a **[snapdrop.net](https://snapdrop.net/)** (o **[localdrop.app](https://localdrop.app/)**).


2. **En tu iPhone:**
* Abre Safari y entra exactamente a la misma página web.
* Verás aparecer el ícono de tu iPhone en la pantalla de la laptop y viceversa (representados con nombres de animales y colores aleatorios).


3. **Para enviar:**
* Toca el ícono del dispositivo de destino en cualquiera de los dos aparatos, selecciona la foto o archivo y acéptalo en el receptor.



---

### Opción 3: Servidor FTP o SFTP temporal (Para usuarios avanzados)

Si prefieres no depender de servicios externos y te gusta la terminal de Linux, puedes levantar un servidor rápido en Debian 13 y conectarte desde la app **Archivos** de iOS.

1. **En Debian 13 (usando Python para algo rápido):**
* Abre la terminal en la carpeta donde quieras recibir los archivos.
* Ejecuta un servidor HTTP simple (necesitas Python instalado):
```bash
python3 -m http.server 8000

```


* Anota la IP local de tu Debian (puedes verla escribiendo `ip a` en la terminal).


2. **En tu iPhone:**
* Abre la app **Archivos**, toca los tres puntos arriba a la derecha y selecciona **Conectarse al servidor**.
* Escribe la dirección: `http://[IP-DE-DEBIAN]:8000` y conéctate como invitado. Podrás descargar lo que necesites, aunque para enviar fotos hacia Debian es más cómodo usar las **Opciones 1 o 2**.