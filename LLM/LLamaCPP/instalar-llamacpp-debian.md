# Instalar llama.cpp en Debian 13 y reusar modelos ya descargados

Guía para tener `llama.cpp` instalado de forma propia (no depender de los
binarios internos de LM Studio — ver advertencia en
[reusar-llamacpp-lmstudio.md](../LLMStudio/reusar-llamacpp-lmstudio.md)),
reusando los modelos GGUF que ya se descargaron con LM Studio.

## Por qué compilar desde código (y no `apt`)

Debian no trae `llama.cpp` empaquetado en sus repos oficiales. Compilarlo
es sencillo y tiene ventajas: el binario queda optimizado para la CPU/GPU
exactas de esta máquina, y siempre se puede actualizar a la versión que se
quiera (`git pull`).

Hardware de referencia en esta máquina:

- CPU: Intel i7-11800H, con AVX2/AVX-512 (16 hilos).
- GPU: NVIDIA RTX 3060 Laptop (driver 550.163, compute capability 8.6).
- **No hay CUDA Toolkit instalado** (`nvcc` no existe) — instalarlo es
  pesado (varios GB). En su lugar se usa el backend **Vulkan**, que ya
  tiene todo lo necesario vía los drivers NVIDIA existentes
  (`libnvidia-glvkspirv`, `nvidia-vulkan-common`) y solo requiere paquetes
  livianos de desarrollo.

## 1. Dependencias de compilación

```bash
sudo apt install build-essential cmake git libvulkan-dev glslc spirv-headers
```

- `build-essential`, `cmake`, `git`: ya están en esta máquina (gcc 14.2,
  cmake 3.31), pero se listan para instalación en otra.
- `libvulkan-dev`: headers de Vulkan para compilar el backend GPU.
- `glslc`: el compilador de shaders que llama.cpp necesita en tiempo de
  build para el backend Vulkan.

> **Ojo:** el paquete `glslang-tools` (que suena obvio) **no** trae
> `glslc` — solo instala `glslang`/`glslangValidator`/`spirv-remap`. El
> binario `glslc` viene en su propio paquete, llamado literalmente
> `glslc` (basado en `shaderc`). Si ya instalaste `glslang-tools` y el
> `cmake` sigue fallando con `Could NOT find Vulkan (missing: glslc)`,
> falta instalar este paquete aparte:
> ```bash
> sudo apt install glslc
> which glslc   # debe resolver a /usr/bin/glslc
> ```
>
> Tras resolver `glslc`, el siguiente error típico es que falte
> `SPIRV-Headers` (`Could not find a package configuration file provided
> by "SPIRV-Headers"`). Se soluciona instalando su paquete aparte:
> ```bash
> sudo apt install spirv-headers
> ```

## 2. Clonar y compilar

```bash
git clone https://github.com/ggml-org/llama.cpp ~/Dev/Pkg/llama.cpp
cd ~/Dev/Pkg/llama.cpp

cmake -B build -DGGML_VULKAN=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release -j"$(nproc)"
```

Esto genera los binarios en `build/bin/`, entre ellos `llama-server` y
`llama-cli`.

Actualizar más adelante:

```bash
cd ~/Dev/Pkg/llama.cpp && git pull && cmake --build build -j"$(nproc)"
```

## 3. Dejarlo accesible en el PATH

```bash
mkdir -p ~/.local/bin
ln -sf ~/Dev/Pkg/llama.cpp/build/bin/llama-server ~/.local/bin/llama-server
ln -sf ~/Dev/Pkg/llama.cpp/build/bin/llama-cli ~/.local/bin/llama-cli
```

(`~/.local/bin` debe estar en `$PATH`; en Debian con bash suele estarlo
por defecto si la carpeta existe al iniciar sesión). El symlink apunta al
binario dentro de `build/bin/`, así que al recompilar con `git pull` no
hace falta rehacerlo.

## 4. Probar: listar los dispositivos

Como ya quedó en el `PATH`, se puede invocar por nombre desde cualquier
carpeta, sin la ruta `./build/bin/...`:

```bash
llama-server --list-devices
```

Salida esperada (ejemplo):

```bash
0.00.000.240 I srv  llama_server: initializing ...
Available devices:
  Vulkan0: Intel(R) UHD Graphics (TGL GT1) (7815 MiB, 7033 MiB free)
  Vulkan1: NVIDIA GeForce RTX 3060 Laptop GPU (6144 MiB, 5925 MiB free)
```

## 5. Encontrar los modelos GGUF ya descargados

LM Studio es cómodo justamente para esto: descarga el `.gguf` correcto
según la compatibilidad del modelo, a diferencia de Ollama que los guarda
como blobs con nombre hash (`sha256-<hash>`), difíciles de identificar sin
pasar por sus manifests.

> Carpeta de descargas movida: en esta máquina la carpeta de modelos de
> LM Studio se cambió de `~/.lmstudio/models` a `~/Dev/LMmodels` — se
> actualizó en `downloadsFolder` dentro de `~/.lmstudio/settings.json`
> (LM Studio lo respeta sin más pasos; no hace falta reinstalar ni mover
> nada dentro de la app). Los ejemplos de abajo ya usan la ruta nueva.

Listar todo lo ya descargado:

```bash
find ~/Dev/LMmodels -iname '*.gguf'
```

Ejemplo real en esta máquina (quedó plano, sin subcarpetas
`<publisher>/<repo>`):

```
~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf
~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf
~/Dev/LMmodels/mmproj-Bonsai-27B-BF16.gguf
```

Un pequeño helper para listar con tamaño y elegir rápido (agregar a
`~/.bashrc` si se usa seguido):

```bash
lmodels() {
  find ~/Dev/LMmodels -iname '*.gguf' -printf '%s\t%p\n' \
    | sort -n | awk -F'\t' '{printf "%6.1f GB  %s\n", $1/1e9, $2}'
}
```

```bash
$ lmodels
   3.8 GB  ~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf
   4.7 GB  ~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf
   ...
```

### Alternativa: que `llama-server` los detecte solo (modo router)

`llama-server` tiene un **modo router** (`--models-dir PATH`): escanea un
directorio y expone todos los modelos que encuentra en `/v1/models`,
cargándolos bajo demanda por nombre (sin tener que elegir `--model` a
mano ni reiniciar por cada modelo).

Como `~/Dev/LMmodels` quedó **plano** (los `.gguf` sueltos, sin
subcarpeta), apunta directo sin necesidad de ningún directorio puente:

```bash
llama-server --models-dir ~/Dev/LMmodels --port 8080 --n-gpu-layers 999
```

```bash
curl http://localhost:8080/v1/models
# {"data":[{"id":"Bonsai-27B-Q1_0", ...}, {"id":"LFM2.5-8B-A1B-Q4_0", ...}]}
```

Cualquier request a `/v1/chat/completions` con `"model": "LFM2.5-8B-A1B-Q4_0"`
carga ese modelo al vuelo (dentro del límite de `--models-max`, 4 por
defecto).

> **Modelos con `mmproj` (visión):** en un directorio plano, el router
> **no** asocia el `mmproj-*.gguf` con su modelo — lo comprobado devuelve
> solo 2 modelos (`Bonsai-27B-Q1_0` y `LFM2.5-8B-A1B-Q4_0`), ignorando
> `mmproj-Bonsai-27B-BF16.gguf` como modelo aparte, pero sin adjuntarlo a
> `Bonsai-27B-Q1_0`. Para que la visión funcione bajo modo router hay que
> meter modelo + `mmproj` juntos en su propia subcarpeta de un nivel
> (`~/Dev/LMmodels/Bonsai-27B/{Bonsai-27B-Q1_0.gguf,mmproj-Bonsai-27B-BF16.gguf}`)
> — ahí sí los asocia automáticamente. Sirviendo con `--model` a mano
> (sección 6) no hay problema: se pasa `--mmproj` explícito.

**No es automático del todo** — no hay detección en vivo del filesystem.
Cuando descargues un modelo nuevo desde LM Studio hay que forzar el
re-escaneo, sin reiniciar el server:

```bash
curl "http://localhost:8080/v1/models?reload=1"
```

> Sobre Ollama: los modelos que descargó quedan en
> `/usr/share/ollama/.ollama/models/{blobs,manifests}` como archivos
> `sha256-<hash>` sin extensión `.gguf` — el nombre real solo se puede
> resolver leyendo el manifest JSON correspondiente. No vale la pena
> migrarlos: es más simple volver a descargar el mismo modelo desde LM
> Studio (queda con nombre legible) que rescatar el blob de Ollama.

## 6. Servir un modelo

```bash
llama-server \
  --model ~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf \
  --port 8080 \
  --ctx-size 8192 \
  --n-gpu-layers 999
```

- `--n-gpu-layers 999`: intenta cargar todas las capas posibles en GPU
  (si no entra en VRAM, `llama-server` reparte automáticamente el resto en
  CPU).
- Queda escuchando en `http://localhost:8080`, con API compatible con
  OpenAI (`/v1/chat/completions`, `/v1/completions`, `/v1/models`).

### UI web (viene incluida, no hay que instalar nada aparte)

`llama-server` sirve una interfaz de chat propia en la raíz. Con el
servidor corriendo, abrir en el navegador:

```
http://localhost:8080
```

Es una UI simple tipo chat (histórico de conversaciones, parámetros de
sampling ajustables desde la interfaz, streaming de la respuesta) — no
requiere ningún paso de instalación extra ni tocar `curl`/la API a mano.

Probar por API (opcional, si se prefiere scriptear en vez de usar la UI):

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hola, ¿quién eres?"}]
  }'
```

### Uso puntual sin servidor (una sola generación)

```bash
llama-cli \
  --model ~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf \
  --n-gpu-layers 999 \
  -p "Hola, ¿quién eres?"
```

## Notas

- No correr `llama-server` propio y LM Studio cargando el **mismo**
  modelo al mismo tiempo si la VRAM es ajustada (cada proceso reserva su
  propia copia en GPU).
- Los `.gguf` de LM Studio son de solo lectura para este uso — no hace
  falta copiarlos, `--model` acepta la ruta directa dentro de
  `~/Dev/LMmodels/...`.
