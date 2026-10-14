# Desactivar la memoria automática de Claude Code

Claude Code guarda "memorias" por proyecto y carga su índice (`MEMORY.md`) en
cada sesión, lo que consume contexto. Si prefieres pasar tus propios archivos
`.md` según el trabajo, se puede apagar.

---

## 1. Dónde vive

```
~/.claude/projects/<ruta-del-proyecto>/memory/MEMORY.md   # índice, se carga en cada sesión
~/.claude/projects/<ruta-del-proyecto>/memory/*.md        # una memoria por archivo
```

## 2. Desactivarla (global)

En `~/.claude/settings.json`, agregar a nivel raíz:

```json
"autoMemoryEnabled": false
```

Alternativa sin tocar el archivo, por variable de entorno:

```bash
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
```

Aplica a sesiones nuevas (CLI y extensión de VS Code).

## 3. Efecto

- Ya no se carga `MEMORY.md` ni se escriben memorias nuevas.
- Los archivos existentes **no se borran**; quedan en disco sin usarse.
- Sigue cargándose lo que tú aportes: `CLAUDE.md`, archivos que pases, etc.

## 4. Limpieza (opcional)

```bash
ls ~/.claude/projects/*/memory/     # revisar antes de borrar
rm -r ~/.claude/projects/*/memory   # irreversible
```

Caso verificado (2026-10-14): aplicado en settings.json; ~181 archivos de
memoria previos conservados.
