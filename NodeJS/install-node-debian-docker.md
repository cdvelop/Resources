# Como Usar **Node.js dentro de Docker** 
>es una manera muy limpia de trabajar sin “ensuciar” tu Debian 12 con dependencias globales ni versiones conflictivas.

---

### 🧠 Concepto

Cuando usas Docker, no instalas Node.js directamente en tu sistema, sino que lo ejecutas **dentro de un contenedor** (una especie de mini-sistema Linux aislado).
Tu Debian solo necesita tener **Docker instalado**. Todo lo demás vive dentro del contenedor.

---

### ⚙️ Qué hace cada comando

```bash
# 1️⃣ Descarga la imagen oficial de Node.js basada en Alpine (ligera)
docker pull node:22-alpine
```

➡️ Esto descarga una imagen con Node.js 22 y npm ya instalados.
No cambia nada en tu sistema: solo agrega una imagen en Docker.

---

```bash
# 2️⃣ Crea y abre un contenedor temporal con Node.js
docker run -it --rm --entrypoint sh node:22-alpine
```

➡️ Este comando:

* `-it` → te permite interactuar con el contenedor (modo terminal).
* `--rm` → lo elimina automáticamente al salir (no deja basura).
* `--entrypoint sh` → abre una shell (`sh`) dentro del contenedor.

Una vez dentro, estás en una **mini consola Linux aislada** con Node instalado.

---

```bash
# 3️⃣ Verifica las versiones
node -v
npm -v
```

Deberías ver algo como:

```
v22.20.0
10.9.3
```

---

### 💻 Cómo usarlo para proyectos

Si tienes un proyecto en tu carpeta local (por ejemplo en `~/mis-proyectos/app`), puedes “montar” esa carpeta dentro del contenedor:

```bash
docker run -it --rm -v "$PWD":/app -w /app node:22-alpine sh
```

Esto significa:

* `-v "$PWD":/app` → comparte tu carpeta actual dentro del contenedor en `/app`.
* `-w /app` → cambia el directorio de trabajo dentro del contenedor.

Dentro del contenedor puedes hacer:

```bash
npm install
npm run dev
```

Y todo quedará en tu carpeta local, sin tocar tu sistema operativo.

---

### 🧹 Ventajas

✅ No instalas nada en Debian (solo Docker).
✅ Puedes probar distintas versiones de Node fácilmente.
✅ Se elimina todo al salir.
✅ Tu entorno real queda limpio.

---


