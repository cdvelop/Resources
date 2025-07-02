# AIDER
https://youtu.be/51TVSMrEtJ0?si=qriKiHax0Nkx1bBF


# instalación en windows:
https://aider.chat/docs/install.html
```bash
powershell -ExecutionPolicy ByPass -c "irm https://aider.chat/install.ps1 | iex"
```


# variables de entorno para conectarse a llms
https://aider.chat/docs/llms.html
ej:
GEMINI_API_KEY
GROQ_API_KEY
- https://console.groq.com/docs/models

# seleccionar modelo:
```bash
aider --model groq/llama3-70b-8192
```

# listar modelos:
```bash
aider --list-models gemini/
```
```bash
aider --list-models deepseek/
```


# escuchar cambios en los archivos
https://aider.chat/docs/usage/watch.html
https://youtu.be/70GpYED1h5s?si=lm7MXkSuQ3XXaShr&t=111
```bash 
aider --watch-files
```

> hacer que aider use dos modelos uno para pensar y otro para editar en el archivo de configuración
https://youtu.be/70GpYED1h5s?si=KdXN-v5eh-jQ5bBS&t=518
.aider.conf.yml
```yml
model: gemini/gemini-2.0-flash-thinking-exp-1219
editor-model: gemini/gemini-2.0-flash-exp

# DEEPSEEK
model: deepseek/deepseek-coder
```

# ejemplo de uso con aplicación docker
https://youtu.be/nYFrdypdsTk?si=DzCWenOPmcdxukOy&t=382