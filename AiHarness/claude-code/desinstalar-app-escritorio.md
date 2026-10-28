# Desinstalar la app de escritorio de Claude (Linux) conservando Claude Code en VS Code

La app de escritorio (`claude-desktop`) y la extensión de VS Code
(`anthropic.claude-code`) son instalaciones independientes. Se puede quitar
la primera sin afectar a la segunda.

---

## 1. Qué hay instalado

```bash
dpkg -l | grep -i claude                       # app de escritorio (.deb)
ls ~/.vscode/extensions | grep -i anthropic    # extensión de VS Code
which -a claude                                # CLI global (si existe)
npm ls -g --depth=0 | grep -i claude           # CLI instalada por npm
```

Caso verificado (2026-10-14, Debian): solo `claude-desktop 2.37337.1` (.deb) y
`anthropic.claude-code-2.1.296-linux-x64`. Sin CLI global ni npm.

## 2. Quitar la app de escritorio

```bash
sudo apt remove claude-desktop     # conserva configuración del sistema
sudo apt purge claude-desktop      # también borra configuración del sistema
```

### Quitar el repositorio APT (obligatorio si lo añadiste a mano)

El paquete solo limpia lo que él mismo registró. Si seguiste el paso manual de
la instalación (crear el `.list` y descargar la llave), `apt remove/purge`
**borra el llavero pero deja el `.list`**, y desde entonces `apt update` falla:

```text
Failed to parse keyring "/usr/share/keyrings/claude-desktop-archive-keyring.asc":
No such file or directory
```

```bash
ls /etc/apt/sources.list.d/ | grep -i claude
sudo rm /etc/apt/sources.list.d/claude-desktop.list
sudo apt update                    # debe terminar sin Err: de downloads.claude.ai
```

Detalle del error y alternativa: `~/Dev/Resources/Linux/Debian13/claude-desktop-apt-keyring-faltante.md`.

### Datos de usuario de la app (opcional)

```bash
ls ~/.config | grep -i claude      # normalmente ~/.config/Claude
rm -rf ~/.config/Claude            # solo datos de la app de escritorio
```

## 3. Qué NO tocar

- `~/.claude/` — planes, historial, ajustes y (si está activa) memorias de **Claude Code**.
  Ver [desactivar-memoria-automatica.md](desactivar-memoria-automatica.md).
  La extensión de VS Code lo usa; borrarlo pierde el contexto de las sesiones.
- `~/.vscode/extensions/anthropic.claude-code-*` — la extensión.

La extensión incluye su propio binario, así que no depende de la app de
escritorio ni de una CLI global.
