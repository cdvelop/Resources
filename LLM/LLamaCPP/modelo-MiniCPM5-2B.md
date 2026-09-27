# MiniCPM5-2B — cómo servirlo con llama.cpp en esta máquina

- Archivo local: `~/Dev/LMmodels/MiniCPM5-2B-Q4_K_M.gguf`
- Ficha oficial (OpenBMB): [huggingface.co/openbmb/MiniCPM5-2B-GGUF](https://huggingface.co/openbmb/MiniCPM5-2B-GGUF)

## Qué es (según la ficha oficial)

Segundo modelo de la serie **MiniCPM5** de OpenBMB (2.6B parámetros
densos, no MoE — confirmado en el GGUF: `general.architecture = llama`,
42 capas). Pensado para asistentes locales, agentes de código, workflows
con herramientas y razonamiento en un modelo compacto. Soporta modo de
razonamiento (`enable_thinking=True` en su chat template) y **tool
calling en formato XML** — la propia ficha aclara que para tool-calling
en producción recomiendan **SGLang** antes que llama.cpp, que lo soporta
mejor.

- Contexto máximo: **131,072 tokens** (`llama.context_length = 131072`
  en el GGUF).

## Sampling recomendado (oficial) — ojo con `min_p`

| Parámetro | Valor |
|---|---|
| temperature | 1.0 |
| top_p | 0.95 |
| min_p | **0.0** |
| repetition_penalty (opcional, si se repite) | 1.05 |

La ficha hace una advertencia específica: el default de `llama-server`
para `min_p` es **0.05** (confirmado con `--help` en esta máquina), y ese
valor filtra tokens por debajo del 5% de probabilidad del más probable —
con este modelo eso **causa repetición**. Hay que pasar `--min-p 0.0`
explícito, no dejarlo en el default.

## Chat template — flag `--jinja`

La ficha pide correr `llama-server` con `--jinja` para que use el motor
de templates Jinja del propio GGUF en vez de una plantilla built-in
aproximada. En la build de esta máquina `--jinja` ya viene habilitado
por defecto, pero se deja explícito en el comando por las dudas (y por
si se actualiza llama.cpp y cambia el default).

## Cómo correrlo en esta máquina

Hardware: NVIDIA RTX 3060 Laptop (6 GB VRAM, dispositivo Vulkan `Vulkan1`
en esta máquina), sin CUDA Toolkit — backend Vulkan.

El archivo Q4_K_M pesa solo 1.45 GiB — el más chico de los que tenés
descargados, entra sobrado en los 6 GB de VRAM incluso con contexto
grande. Único detalle: al ser atención densa normal (no híbrida como
LFM2.5 o Bonsai), la cache KV **sí** crece proporcional al contexto — el
contexto máximo de 131072 tokens no entra completo junto a los pesos en
6 GB VRAM (la cache KV sola a full contexto pesa según cuentas ~5 GB).
Se comprobó que con `--ctx-size 32768` carga cómodo, usando 2.7 GB de
6 GB de VRAM — deja margen de sobra:

```bash
llama-server \
  --model ~/Dev/LMmodels/MiniCPM5-2B-Q4_K_M.gguf \
  --port 9090 \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 32768 \
  --jinja \
  --temp 1.0 \
  --top-p 0.95 \
  --min-p 0.0 \
  --chat-template-kwargs '{"enable_thinking": false}'
```

Este es el comando "óptimo" para uso general en esta máquina: entra
entero en VRAM, usa el sampling oficial, y trae el razonamiento
**desactivado por defecto** (ver por qué en la sección de abajo) para que
el chat casual responda directo en vez de pensar de más. Si se necesita
más contexto que 32768, se puede subir gradualmente (p. ej. 65536)
mientras la VRAM lo permita — con este modelo tan chico hay margen para
probarlo sin miedo a romper nada más en el sistema.

### Uso puntual (una sola generación, sin servidor)

```bash
llama-cli \
  --model ~/Dev/LMmodels/MiniCPM5-2B-Q4_K_M.gguf \
  --device Vulkan1 \
  --n-gpu-layers 99 \
  --ctx-size 32768 \
  --jinja \
  --temp 1.0 --top-p 0.95 --min-p 0.0 \
  -p "Hola, ¿quién eres?"
```

## Por qué el comando trae `enable_thinking: false`

Por defecto (sin ese flag), MiniCPM5 genera un bloque de razonamiento
oculto (`reasoning_content` en la respuesta de la API) **antes** de
cualquier respuesta, incluso para algo tan simple como "Hola". Se
comprobó contra el servidor corriendo en esta máquina: con un "Hola" el
modelo generó un `reasoning_content` de ~100 tokens ("the user just said
'Hola'... I should respond politely...") antes de la respuesta real —
eso, sumado al costo único de "calentamiento" del backend Vulkan en el
primer mensaje tras arrancar el servidor, es lo que se siente como una
demora larga en el primer "Hola".

Para uso general/chat casual (el caso de uso principal en esta máquina)
tiene más sentido apagarlo, por eso ya viene en el comando de arriba —
confirmado que sin el flag la respuesta trae `reasoning_content` y tarda
notablemente más; con el flag responde directo.

**Si en una conversación puntual se necesita razonamiento explícito**
(un problema que sí lo amerite), se puede volver a activar por request
sin tocar el servidor, mandándolo en la llamada:

```bash
curl http://localhost:9090/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "..."}],
    "chat_template_kwargs": {"enable_thinking": true}
  }'
```

## Nota sobre tool calling

Si el uso principal es agentic/tool-use, la propia ficha de OpenBMB
recomienda **SGLang** en vez de llama.cpp para ese caso — el soporte de
`llama-server` para el formato XML de tool calls de MiniCPM5 puede ser
menos robusto. Para chat normal / razonamiento, `llama-server` con
`--jinja` funciona sin problema.
