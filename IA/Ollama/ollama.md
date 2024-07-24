# descargar modelos 

ollama.com/library

con ollama corriendo ejecutar:

```bash
ollama run gemma:2b
```

# personalizar modelo con el fichero Modelfile
https://github.com/ollama/ollama/blob/main/docs/modelfile.md#from-required

1- Save it as a file (e.g. Modelfile)
2- ollama create <mi-modelo-gpt> -f <location of the file e.g. ./Modelfile>'
3- ollama run <mi-modelo-gpt>
