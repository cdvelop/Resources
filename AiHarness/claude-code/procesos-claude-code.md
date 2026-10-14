# Ver y detener procesos de Claude Code (extensión de VS Code)

La extensión lanza un binario `claude` por cada conversación abierta, no uno
solo. Una pestaña de chat olvidada mantiene su proceso vivo (ocioso, ~1,7 % de
RAM) hasta que se cierra la pestaña o se reinicia VS Code.

---

## 1. Listar procesos (versión legible)

```bash
./claude-procesos.sh        # script en esta misma carpeta
```

Salida de ejemplo:

```
PID      ABIERTO HACE   CPU    RAM(MB)  ESTADO      CARPETA
64357    23h 44m        0.0%   273      en espera   ~/Dev/Project
445390   24m            0.8%   308      EJECUTANDO  ~/Dev/Project
```

Cómo leerla (cada fila = una conversación abierta en VS Code):

- **PID**: número que se usa con `kill`.
- **ABIERTO HACE**: cuánto lleva viva esa conversación.
- **RAM(MB)**: memoria que ocupa (~280 MB cada una).
- **ESTADO**:
  - `en espera` → ociosa, solo ocupa memoria. Candidata a cerrar.
  - `EJECUTANDO` → está corriendo un comando ahora mismo. Suele ser la sesión
    que estás usando mientras le pides algo; no la mates.
- **CARPETA**: proyecto desde el que se abrió.

Nota: el script no muestra el título de la conversación. Para saber a qué
pestaña corresponde un PID, cierra pestañas y vuelve a correr el script.

Versión cruda (difícil de leer, sin script):

```bash
ps -eo pid,ppid,etime,%cpu,%mem,args --sort=-etimes | grep -E "claude|anthropic" | grep -v grep | cut -c1-200
```

Ahí `etime` es `horas:min:seg` (o `días-horas:...`) y `%mem` es % de la RAM total.

## 2. Detener (de menos a más drástico)

1. **Cerrar la pestaña del chat** en VS Code: termina su proceso. Es la forma limpia.
2. **Reiniciar la extensión**: paleta de comandos → `Developer: Restart Extension Host`.
   Cierra todos los procesos; las conversaciones se pueden reanudar después.
3. **Matar un proceso concreto**:
   ```bash
   kill <PID>        # normal
   kill -9 <PID>     # solo si no responde
   ```
   Cierra esa conversación sin aviso. No mates el PID de la sesión que estás
   usando (el que tiene hijos mientras ejecutas algo).

## 3. Cuántos debería haber

Uno por conversación abierta. Para tener solo uno: dejar un único chat abierto
y cerrar los demás. Caso verificado (2026-10-14): 4 procesos, 3 ociosos desde
hacía ~23 h.
