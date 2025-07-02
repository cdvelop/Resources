Para pasar la variable de entorno de tu host al contenedor Docker, usa la opción `-e` o `--env`:

```bash
docker run -e HF_TOKEN=$HF_TOKEN -v $HOME/LLM/models:/models -p 8000:8000 llama-cpp-server
```

Variantes adicionales:

1. Pasar directamente el valor:
```bash
docker run -e HF_TOKEN="tu_token_aqui" -v $HOME/LLM/models:/models -p 8000:8000 llama-cpp-server
```

2. Si quieres usar todas las variables de entorno del host:
```bash
docker run --env-file <(env) -v $HOME/LLM/models:/models -p 8000:8000 llama-cpp-server
```

3. Usando un archivo `.env`:
- Crea un archivo `.env`:
```
HF_TOKEN=tu_token_aqui
```
- Ejecuta:
```bash
docker run --env-file .env -v $HOME/LLM/models:/models -p 8000:8000 llama-cpp-server
```

La opción `-e HF_TOKEN=$HF_TOKEN` es generalmente la más directa y segura, pasando el valor de tu variable de host al contenedor.


# ARGUMENTOS ENV EN DOCKERFILE

En un Dockerfile, las variables de entorno definidas con `ENV` son procesadas durante la construcción de la imagen, no durante la ejecución del contenedor. Para resolver esto y permitir que `LOCAL_LLM` sea configurable en tiempo de ejecución, tienes varias opciones:

1. Usar ARG durante la construcción y ENV para el tiempo de ejecución:

```dockerfile
ARG LOCAL_LLM
ENV MODEL_URL="https://huggingface.co/TheBloke/Llama-3-8B-Instruct-GGUF/resolve/main/${LOCAL_LLM}"
ENV MODEL_NAME="${LOCAL_LLM}"
```

2. Usar valores por defecto y permitir sobrescritura:

```dockerfile
ARG LOCAL_LLM=llama-3-8b-instruct.Q4_K_M.gguf
ENV MODEL_URL="https://huggingface.co/TheBloke/Llama-3-8B-Instruct-GGUF/resolve/main/${LOCAL_LLM}"
ENV MODEL_NAME="${LOCAL_LLM}"
```

3. Modificar el script de descarga para usar variables de entorno en tiempo de ejecución:

```bash
#!/bin/sh

# Usar variables de entorno si están definidas, de lo contrario usar valores por defecto
MODEL_URL="${MODEL_URL:-https://huggingface.co/TheBloke/Llama-3-8B-Instruct-GGUF/resolve/main/${LOCAL_LLM}}"
MODEL_NAME="${MODEL_NAME:-${LOCAL_LLM}}"

# Resto del script permanece igual...

```

Entonces, al ejecutar el contenedor, podrías hacer:

```bash
docker run \
  -e HF_TOKEN=$HF_TOKEN \
  -e LOCAL_LLM=llama-3-8b-instruct.Q4_K_M.gguf \
  -v $HOME/LLM/models:/models \
  -p 8000:8000 \
  llama-cpp-server
```

Construcción de la imagen:
```bash
docker build \
  --build-arg LOCAL_LLM=llama-3-8b-instruct.Q4_K_M.gguf \
  -t llama-cpp-server \
  .
```

Esto te da flexibilidad para:
- Definir un modelo por defecto
- Sobrescribir el modelo en tiempo de ejecución
- Mantener la configuración dinámica