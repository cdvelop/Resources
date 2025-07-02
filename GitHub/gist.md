# GitHub Gist

GitHub Gist es un servicio que permite compartir fragmentos de código, notas y archivos de manera rápida y sencilla.

## Características principales:
- Compartir código instantáneamente
- Soporte para múltiples archivos
- Control de versiones
- Permite comentarios
- Puede ser público o privado
- Integración con GitHub

Los Gists son especialmente útiles para:
- Compartir snippets de código
- Almacenar notas técnicas
- Crear ejemplos rápidos
- Colaborar en pequeños proyectos

## Ejemplo de uso con línea de comando

1. **Crear un nuevo Gist usando gh cli**
    ```bash
    # Crear un gist público con un archivo
    gh gist create archivo.txt

    # Crear un gist privado con múltiples archivos
    gh gist create codigo1.js codigo2.py -d "Mi descripción"

    # Crear un gist desde stdin
    echo "console.log('Hola')" | gh gist create -f script.js
    ```

2. **Administrar Gists existentes**
    ```bash
    # Listar tus gists
    gh gist list

    # Ver un gist específico
    gh gist view <id-del-gist>

    # Clonar un gist
    gh gist clone <id-del-gist>
    ```