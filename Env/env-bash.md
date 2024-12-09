# variables de entorno en bash

En GitBash en Windows, puedes ver las variables de entorno de varias maneras:

1. Usando `echo`:
```bash
echo $HF_TOKEN
```

2. Usando el comando `env`:
```bash
env | grep HF_TOKEN
```

3. Para configurar la variable de entorno:
```bash
# Configurar temporalmente (solo en la sesión actual)
export HF_TOKEN=your_hugging_face_token

# Verificar que se haya establecido
echo $HF_TOKEN
```

4. Si quieres guardar la variable para futuras sesiones:
- Edita el archivo `~/.bashrc` o `~/.bash_profile`
- Agrega al final del archivo:
```bash
export HF_TOKEN=your_hugging_face_token
```
- Luego recarga la configuración:
```bash
source ~/.bashrc
```

Consejos adicionales:
- Asegúrate de no incluir espacios alrededor del `=`
- Pon el token entre comillas si contiene caracteres especiales
- No compartas el archivo ni lo subas a repositorios públicos

Para ver todas las variables de entorno:
```bash
# Mostrar todas las variables de entorno
env
```

En GitBash para Windows, puedes configurar variables de entorno permanentes de manera sencilla:

1. Edita el archivo `.bashrc` en tu directorio de usuario:
```bash
nano ~/.bashrc
```

2. Al final del archivo, agrega la línea para exportar la variable:
```bash
export HF_TOKEN="tu_token_aqui"
```

3. Guarda el archivo:
- Si estás en nano: Presiona `Ctrl + X`, luego `Y`, y `Enter`

4. Para que surta efecto inmediatamente sin reiniciar, ejecuta:
```bash
source ~/.bashrc
```

5. Verifica que la variable esté configurada:
```bash
echo $HF_TOKEN
env | grep HF_TOKEN
```

Consejos adicionales:
- Asegúrate de no compartir el token públicamente
- Usa comillas si el token contiene caracteres especiales
- El archivo `.bashrc` se ejecuta cada vez que abres una terminal GitBash

Alternativa para Windows (variables de sistema):
1. Abre "Panel de Control > Sistema > Configuración avanzada del sistema"
2. Haz clic en "Variables de entorno"
3. En "Variables de usuario" o "Variables del sistema", selecciona "Nuevo"
4. Agrega nombre (HF_TOKEN) y valor del token

Método con línea de comandos de Windows (PowerShell como administrador):
```powershell
[Environment]::SetEnvironmentVariable("HF_TOKEN", "tu_token_aqui", "User")
```

¿Necesitas ayuda con algún paso específico?
