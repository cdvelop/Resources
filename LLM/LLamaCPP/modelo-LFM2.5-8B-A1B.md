# LFM2.5-8B-A1B — cómo servirlo con llama.cpp en esta máquina

- Archivo local: `~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf`
- Ficha oficial: [huggingface.co/LiquidAI/LFM2.5-8B-A1B](https://huggingface.co/LiquidAI/LFM2.5-8B-A1B)
- GGUF oficial: [huggingface.co/LiquidAI/LFM2.5-8B-A1B-GGUF](https://huggingface.co/LiquidAI/LFM2.5-8B-A1B-GGUF)

## Qué es (según la ficha oficial)

Combina el backbone híbrido **LFM2** (bloques de convolución compuerta de
rango corto intercalados con atención grouped-query) con capas MoE
(Mixture-of-Experts) dispersas: calidad "clase 8B" con un costo de
decodificación de solo ~1B parámetros activos por token (de ahí "A1B" —
Active 1B). Confirmado en los metadatos del propio GGUF
(`general.architecture = lfm2moe`, `expert_count = 32`,
`expert_used_count = 4`, `size_label = 32x959M`).

- Emite un `<think>…</think>` explícito antes de la respuesta final en
  problemas no triviales (modelo de razonamiento).
- Soporta **tool calling** en formato "Pythonic": el modelo llama
  funciones entre `<|tool_call_start|>` / `<|tool_call_end|>`.
- Uso recomendado por el autor: workflows agénticos, uso de
  herramientas, salidas estructuradas, asistentes multilingües y
  asistentes on-device. **No** es el mejor fit para programación pesada
  o preguntas de conocimiento intensivo sin RAG.
- Contexto de entrenamiento: **128,000 tokens** (`max_position_embeddings
  = 128000`, confirmado también en el GGUF: `lfm2moe.context_length =
  128000`).

## Plantilla de chat (oficial)

Formato tipo ChatML:

```
<|startoftext|><|im_start|>system
[mensaje de sistema]<|im_end|>
<|im_start|>user
[mensaje de usuario]<|im_end|>
<|im_start|>assistant
```

El GGUF ya trae el `chat_template` de Jinja embebido (metadato
`tokenizer.chat_template`), así que `llama-server` lo aplica solo — no
hay que pasarlo a mano.

## Sampling recomendado (oficial)

| Parámetro | Valor |
|---|---|
| temperature | 0.2 |
| top_k | 80 |
| repetition_penalty | 1.05 |

Estos son los valores que documenta LiquidAI, distintos a los que trae
por defecto el propio `llama-server` — hay que pasarlos explícitos.

## Cómo correrlo en esta máquina

Hardware: NVIDIA RTX 3060 Laptop (6 GB VRAM, dispositivo Vulkan `Vulkan1`
en esta máquina — ver `llama-server --list-devices`), sin CUDA Toolkit
instalado (se usa el backend Vulkan compilado según
[instalar-llamacpp-debian.md](instalar-llamacpp-debian.md)).

El archivo cuantizado Q4_0 pesa 4.5 GiB — **entra completo en los 6 GB de
VRAM** de la RTX 3060, así que conviene ofloadear todas las capas a la
GPU en vez de repartir con `--n-cpu-moe` (ese flag existe para cuando el
modelo *no* entra entero en VRAM; acá si se usa, solo se pierde
rendimiento sin necesidad).

```bash
llama-server \
  --model ~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf \
  --port 8080 \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 32768 \
  --temp 0.2 \
  --top-k 80 \
  --repeat-penalty 1.05
```

- `--device Vulkan1`: fuerza el uso de la NVIDIA dedicada y no la iGPU
  Intel (`Vulkan0`, mucho más lenta y con memoria compartida).
- `--n-gpu-layers 99`: offload completo (el modelo entero entra en VRAM).
- `--ctx-size 32768`: el contexto de entrenamiento es 128k, pero **no
  entra completo en 6 GB de VRAM junto con los pesos** (se comprobó en
  esta máquina: 128k falla por falta de memoria en la GPU; 32k deja
  margen cómodo). Si se necesita más contexto, la alternativa es bajar
  `--n-gpu-layers` para dejarle sitio a la cache KV, a costa de
  velocidad.
- `--temp`, `--top-k`, `--repeat-penalty`: los valores recomendados por
  LiquidAI (arriba).

### Uso puntual (una generación, sin servidor)

```bash
llama-cli \
  --model ~/Dev/LMmodels/LFM2.5-8B-A1B-Q4_0.gguf \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 32768 \
  --temp 0.2 --top-k 80 --repeat-penalty 1.05 \
  -p "Hola, ¿quién eres?"
```
