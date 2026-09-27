# Reusar el `llama-server` (llama.cpp) que ya trae LM Studio

## Idea

LM Studio no reimplementa la inferencia: por debajo descarga y ejecuta
binarios oficiales de **llama.cpp** (`llama-server`, el servidor HTTP
compatible con la API de OpenAI). Esos binarios quedan guardados en el
home del usuario, fuera de la instalación de la app — así que se pueden
ejecutar directamente, sin instalar llama.cpp por separado ni compilarlo.

## Dónde están

```bash
ls ~/.lmstudio/extensions/backends/
```

Cada carpeta es un "backend" (build de llama.cpp) para una combinación de
plataforma/aceleración/versión, p. ej. en esta máquina:

```
llama.cpp-linux-x86_64-avx2-2.16.0                    # CPU
llama.cpp-linux-x86_64-avx2-2.41.0                    # CPU
llama.cpp-linux-x86_64-vulkan-avx2-2.16.0             # GPU vía Vulkan
llama.cpp-linux-x86_64-vulkan-avx2-2.41.0
llama.cpp-linux-x86_64-nvidia-cuda-avx2-2.16.0        # GPU CUDA 11
llama.cpp-linux-x86_64-nvidia-cuda-avx2-2.41.0
llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.16.0      # GPU CUDA 12
llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.41.0
llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.46.0      # ← la más nueva
vendor/                                               # runtimes de terceros (CUDA, Vulkan)
```

LM Studio va descargando builds nuevas según actualiza la app y conserva
varias en paralelo; la que usa por defecto es la más reciente compatible
con el hardware detectado (aquí: NVIDIA RTX 3060 Laptop → CUDA 12).

Dentro de cada carpeta de backend está el binario real:

```bash
~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.46.0/llama-server
```

Es el mismo `llama-server` que compilarías desde el repo de
[ggml-org/llama.cpp](https://github.com/ggml-org/llama.cpp) — misma CLI,
mismos flags (`--model`, `--ctx-size`, `--n-gpu-layers`, `--port`, etc.).
Se comprobó con `--help` y expone las opciones estándar de llama.cpp.

## Ejecutarlo directamente

### Backend de CPU (autocontenido, sin dependencias extra)

```bash
BACKEND=~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-avx2-2.41.0
"$BACKEND/llama-server" --version
```

Funciona sin nada más: el binario tiene `RPATH=$ORIGIN`, así que resuelve
sus propias `.so` (`libllama.so`, `libggml-*.so`, etc.) desde la misma
carpeta.

### Backend CUDA (necesita las librerías CUDA que trae LM Studio)

El binario CUDA depende de `libcudart.so.12` / `libcublas.so.12`, que
**no** están instaladas a nivel de sistema — LM Studio trae su propia
copia vendorizada en `extensions/backends/vendor/`, para no depender del
toolkit de CUDA del sistema:

```bash
BACKEND=~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.46.0
CUDA_VENDOR=~/.lmstudio/extensions/backends/vendor/linux-llama-cuda12-vendor-v1

LD_LIBRARY_PATH="$CUDA_VENDOR" "$BACKEND/llama-server" --version
```

Confirmado en esta máquina: sin `LD_LIBRARY_PATH` falla con
`libcudart.so.12: cannot open shared object file`; con el vendor de arriba
arranca bien.

Si se prefiere el backend Vulkan, el mismo patrón aplica con
`vendor/linux-llama-vulkan-vendor-v1` (trae su propio `libvulkan.so`, útil
si el sistema no tiene uno compatible).

### Servir un modelo GGUF real

Los modelos que ya descargaste desde LM Studio están en
`~/.lmstudio/models/<publisher>/<repo>/archivo.gguf` — se pueden apuntar
directamente, sin copiarlos ni volver a descargarlos:

```bash
BACKEND=~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.46.0
CUDA_VENDOR=~/.lmstudio/extensions/backends/vendor/linux-llama-cuda12-vendor-v1
MODEL=~/.lmstudio/models/LiquidAI/LFM2.5-8B-A1B-GGUF/LFM2.5-8B-A1B-Q4_0.gguf

LD_LIBRARY_PATH="$CUDA_VENDOR" "$BACKEND/llama-server" \
  --model "$MODEL" \
  --port 8000 \
  --n-gpu-layers 999
```

Esto levanta un servidor HTTP compatible con la API de OpenAI en
`http://localhost:8000`, totalmente independiente del proceso de LM
Studio.

## Advertencias

- **No es un artefacto "estable" para depender de él a largo plazo**: LM
  Studio gestiona estas carpetas él solo (descarga versiones nuevas,
  puede borrar builds viejas al actualizar la app). El nombre de carpeta
  incluye la versión, así que un script que la referencie a pelo puede
  romperse tras una actualización de LM Studio. Si se quiere un path
  estable, conviene resolver la carpeta más reciente en tiempo de
  ejecución (`ls -d ~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-nvidia-cuda12-avx2-* | sort -V | tail -1`)
  en vez de hardcodear la versión.
- **No ejecutar el mismo modelo dos veces a la vez** (una copia dentro de
  LM Studio y otra vía `llama-server` suelto) si la VRAM es ajustada —
  cada proceso carga sus propios pesos en GPU, duplicando el uso de
  memoria.
- Alternativa sin tocar rutas internas: LM Studio trae su propio CLI en
  `~/.lmstudio/bin/lms`, que sabe arrancar/parar el servidor interno y
  gestionar modelos (`lms server start`, `lms load`, etc.) usando estos
  mismos backends por debajo. Útil si lo que se busca es automatizar el
  server "oficial" de LM Studio en vez de un `llama-server` totalmente
  aparte.
