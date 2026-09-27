# Bonsai-27B (+ visión) — cómo servirlo con llama.cpp en esta máquina

- Archivos locales:
  - `~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf` (modelo de texto)
  - `~/Dev/LMmodels/mmproj-Bonsai-27B-BF16.gguf` (proyector de visión)
- Ficha oficial (autor, Prism ML): [huggingface.co/prism-ml/Bonsai-27B-gguf](https://huggingface.co/prism-ml/Bonsai-27B-gguf)
- Colección: [huggingface.co/collections/prism-ml/bonsai-27b](https://huggingface.co/collections/prism-ml/bonsai-27b)
- Nuestro archivo concreto vino de `lmstudio-community/Bonsai-27B-GGUF`, una
  re-cuantización del mismo modelo (mismos pesos, empaquetado distinto —
  ver aclaración de compatibilidad más abajo).

## Qué es (según la ficha oficial)

Modelo de **1 bit** (formato ternario/1-bit) de 27B parámetros: 14.2x de
reducción de memoria respecto al FP16, hasta el punto de correr
interactivamente en laptops comunes. Arquitectura híbrida de atención
("~75% linear attention"), lo que hace práctico un contexto de **262K
tokens on-device** — algo que un transformer denso de 27B jamás podría
sostener en una GPU de este tamaño.

Confirmado en los metadatos del propio GGUF: `general.architecture =
qwen35`, 64 bloques, `context_length = 262144`,
`full_attention_interval = 4` (solo 1 de cada 4 capas usa atención
completa; el resto son capas tipo SSM/Mamba con estado de tamaño fijo,
independiente del largo de contexto — por eso el contexto tan largo es
viable en poca VRAM).

## ⚠️ Aclaración importante: qué build de llama.cpp hace falta

La ficha oficial de Prism ML dice que el formato "óptimo" (`Q1_0_g128`,
pesos empaquetados que nunca se expanden a FP16) requiere **su propio
fork de llama.cpp** ("PrismML fork") con kernels custom de 1 bit.

Nuestro archivo, sin embargo, es la re-cuantización que publicó
**lmstudio-community**, usando el tipo de cuantización **estándar** de
ggml `Q1_0` (`LLAMA_FTYPE_MOSTLY_Q1_0 = 40`, que **sí** existe en el
llama.cpp mainline que compilamos en
[instalar-llamacpp-debian.md](instalar-llamacpp-debian.md)). Se
comprobó: el archivo carga y genera texto normalmente con el binario
`llama-server` de `ggml-org/llama.cpp` sin fork ni parche — **no hace
falta el fork de PrismML** para este archivo en particular. Si en el
futuro se quiere el formato `Q1_0_g128` "óptimo" del autor (más rápido,
según su ficha), habría que compilar ese fork aparte y sería una
instalación de llama.cpp distinta a la de uso general.

## Sampling recomendado (oficial, "settings usados en sus benchmarks")

| Parámetro | Valor |
|---|---|
| temperature | 0.7 |
| top_p | 0.95 |
| top_k | 20 |

(El propio GGUF trae estos mismos `top_k`/`top_p` embebidos como default
—`general.sampling.top_k=20`, `general.sampling.top_p=0.95`—, salvo la
temperatura, que el GGUF trae en 1.0; se prioriza el 0.7 que documenta la
ficha oficial).

## Plantilla / system prompt

La ficha oficial no pide nada especial: sugiere un system prompt simple,
`"You are a helpful assistant"`. El chat template de Jinja ya viene
embebido en el GGUF (`tokenizer.chat_template`), `llama-server` lo aplica
solo.

## Visión (`mmproj`)

La ficha oficial aclara que el componente de visión **normalmente no se
mantiene en la GPU**: "se offloadea fuera del presupuesto residente del
acelerador y solo se carga cuando llega una imagen". Esto importa acá
porque la VRAM es de solo 6 GB y ya la ocupa casi entera el modelo de
texto — hay que decirle a `llama-server` explícitamente que **no**
mande el proyector de visión a GPU:

```bash
--mmproj ~/Dev/LMmodels/mmproj-Bonsai-27B-BF16.gguf \
--no-mmproj-offload
```

## Cómo correrlo en esta máquina

Hardware: NVIDIA RTX 3060 Laptop (6 GB VRAM, dispositivo Vulkan `Vulkan1`
en esta máquina), sin CUDA Toolkit — backend Vulkan.

El archivo Q1_0 pesa 3.53 GiB — **entra completo en los 6 GB de VRAM**
de la RTX 3060 (la ficha oficial también recomienda `-ngl 99` como
flag de referencia). El contexto de entrenamiento es 262k, pero — igual
que con LFM2.5 — no entra completo junto a los pesos en 6 GB; conviene
un contexto más conservador (`--ctx-size 16384`, confirmado que carga
bien en esta máquina) salvo que se libere VRAM bajando `--n-gpu-layers`.

### Solo texto

```bash
llama-server \
  --model ~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf \
  --port 8080 \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 16384 \
  --temp 0.7 \
  --top-p 0.95 \
  --top-k 20
```

### Con visión (modelo + mmproj)

```bash
llama-server \
  --model ~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf \
  --mmproj ~/Dev/LMmodels/mmproj-Bonsai-27B-BF16.gguf \
  --no-mmproj-offload \
  --port 8080 \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 16384 \
  --temp 0.7 \
  --top-p 0.95 \
  --top-k 20
```

### Uso puntual (una sola generación, sin servidor)

```bash
llama-cli \
  --model ~/Dev/LMmodels/Bonsai-27B-Q1_0.gguf \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 16384 \
  --temp 0.7 --top-p 0.95 --top-k 20 \
  -p "Hola, ¿quién eres?"
```
