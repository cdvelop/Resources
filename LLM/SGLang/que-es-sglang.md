# Qué es SGLang

Referenciado desde [modelo-MiniCPM5-2B.md](../LLamaCPP/modelo-MiniCPM5-2B.md)
(OpenBMB lo recomienda ahí por sobre `llama.cpp` para tool-calling en
producción con ese modelo).

- Repo oficial: [github.com/sgl-project/sglang](https://github.com/sgl-project/sglang)
- Docs oficiales: [docs.sglang.io](https://docs.sglang.io/)
- Desarrollado por LMSYS (los mismos de Chatbot Arena / Vicuna).
  Licencia Apache 2.0. Escrito en Python, Rust, CUDA y C++.

## Qué es

Un **framework de inferencia y serving para LLMs**, orientado a
producción a gran escala — no es un motor de "correr un modelo en tu
compu" como `llama.cpp`, sino algo pensado para servir tráfico real con
muchas peticiones simultáneas. Los propios mantenedores dicen que
"genera billones de tokens por día en más de 400,000 GPUs" en despliegues
que lo usan.

### Características principales

- **RadixAttention**: cachea automáticamente los prefijos de prompts
  compartidos entre requests (útil en chat con historial largo, o cuando
  muchos usuarios comparten el mismo system prompt) — evita reprocesar
  el mismo texto una y otra vez.
- **Prefix caching** y **scheduling** optimizado para maximizar
  throughput con múltiples requests concurrentes.
- **Paralelismo multi-GPU** (tensor parallel, pipeline parallel, etc.)
  para repartir un modelo entre varias GPUs.
- **Decodificación especulativa** con drafters específicos por modelo
  (p. ej. "DSpark" para DeepSeek, "MTP" para otros).
- **Salida estructurada** (JSON schema, gramáticas) de forma nativa y
  rápida.
- API compatible con OpenAI, igual que `llama-server`.

## Hardware que targetea

La propia documentación lista como hardware soportado: NVIDIA
**H100/H200/B200/B300/GB300/A100/RTX 5090**, aceleradores AMD
**MI300X/MI325X/MI350X/MI355X**, además de TPUs de Google, NPUs Ascend y
Xeon de Intel. Es decir: **GPUs de datacenter o el tope de gama consumer
(5090, 32 GB VRAM)** — pensado para servir modelos grandes a muchos
usuarios a la vez, no para correr un modelo suelto en una laptop.

## ¿Tiene sentido instalarlo en esta máquina?

**No, al menos no para el uso actual.** Motivos concretos de esta
máquina (ver [instalar-llamacpp-debian.md](../LLamaCPP/instalar-llamacpp-debian.md)):

- No hay CUDA Toolkit instalado — SGLang depende de CUDA (PyTorch +
  runtime CUDA), instalarlo implica bajar varios GB adicionales, a
  diferencia de `llama.cpp` que ya corre bien con Vulkan sin ese peso.
- La GPU es una **RTX 3060 Laptop de 6 GB VRAM** — muy por debajo del
  hardware que SGLang lista como objetivo. Sus ventajas (RadixAttention,
  scheduling para muchos requests concurrentes, paralelismo multi-GPU)
  solo se notan sirviendo tráfico real con concurrencia, no en uso
  personal de un modelo a la vez.
- Para uso personal/local — que es el caso de esta máquina y de los
  modelos documentados en `LLamaCPP/` — `llama.cpp` ya cubre lo
  necesario: un usuario, un modelo cargado, sin necesidad de las
  optimizaciones de throughput multi-usuario de SGLang.

La mención de SGLang en la ficha de MiniCPM5-2B es una recomendación de
OpenBMB pensando en quien lo vaya a **servir en producción con varios
usuarios**; para correrlo localmente en esta laptop, `llama-server` con
`--jinja` (como ya está documentado) es la opción correcta.
