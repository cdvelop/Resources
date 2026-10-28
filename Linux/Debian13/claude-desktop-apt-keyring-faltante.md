# Claude Desktop — llavero APT inexistente en `apt update` — Debian 13

Error que aparece al ejecutar `sudo apt update` cuando el repositorio de Claude Desktop
está registrado pero el archivo de la llave GPG no existe en disco.

---

## 1. Síntoma

```text
Err:10 https://downloads.claude.ai/claude-desktop/apt/stable stable InRelease
  Sub-process /usr/bin/sqv returned an error code (1), error message is: Error: Failed to parse
  keyring "/usr/share/keyrings/claude-desktop-archive-keyring.asc"  Caused by:
  0: Reading "/usr/share/keyrings/claude-desktop-archive-keyring.asc": No such file or directory (os error 2)
...
Warning: An error occurred during the signature verification. The repository is not updated
and the previous index files will be used. OpenPGP signature verification failed:
https://downloads.claude.ai/claude-desktop/apt/stable stable InRelease ...
Warning: Some index files failed to download. They have been ignored, or old ones used instead.
```

El resto de los repositorios (Debian, Docker, Brave, Chrome, etc.) se actualizan con normalidad;
solo falla `downloads.claude.ai`. Al final `apt upgrade` dice `All packages are up to date`
porque usa el índice viejo de ese repo.

---

## 2. Causa

El repo está registrado, pero el archivo del llavero **no existe**:

```text
/etc/apt/sources.list.d/claude-desktop.list
deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main
```

```bash
ls -la /usr/share/keyrings/ | grep -i claude    # (sin salida → el llavero no está)
```

`signed-by=` apunta a una ruta que ya no tiene archivo. Debian 13 verifica con `sqv` (Sequoia),
que falla al no poder leer el llavero.

Causa confirmada en este equipo: se **desinstaló `claude-desktop`** pero el `.list` quedó.

- El `.list` se creó a mano (15-jul) siguiendo el paso manual de instalación, antes de
  instalar el paquete.
- El `.deb` es dueño del llavero, así que `apt remove/purge` lo borra; pero **no** es dueño
  del `.list` creado a mano, por lo que sobrevive y apunta a un llavero inexistente.
- La documentación oficial lo indica: si añadiste el repo tú mismo, hay que borrarlo aparte.

Tutorial de desinstalación (ya con este paso):
`~/Dev/Resources/AiHarness/claude-code/desinstalar-app-escritorio.md`.

`claude-desktop` ya **no figura instalado** (`dpkg -l | grep -i claude` vacío), por lo que
lo correcto es la Solución B.

---

## 3. ¿Es grave?

**No es un problema de seguridad**: APT se niega a confiar en lo que no puede verificar.

- El resto del sistema se actualiza normal.
- Solo se pierden actualizaciones de `claude-desktop`.

Lo que **NO** hay que hacer:

- ❌ `trusted=yes` en el `.list`
- ❌ `--allow-unauthenticated` / `--allow-insecure-repositories`
- ❌ Importar la llave sin comparar la huella

---

## 4. Solución A — Se usa Claude Desktop: reinstalar el llavero

Pasos oficiales ([docs de Claude Desktop en Linux](https://code.claude.com/docs/en/desktop-linux)):

```bash
# 1. Descargar la llave oficial a la ruta que usa signed-by
sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc

# 2. Verificar la huella ANTES de seguir
gpg --show-keys --with-fingerprint /usr/share/keyrings/claude-desktop-archive-keyring.asc

# 3. Probar
sudo apt update
```

En el paso 2 la salida debe ser exactamente:

```text
pub   rsa4096 2026-03-30 [SCE]
      31DD DE24 DDFA B679 F42D  7BD2 BAA9 29FF 1A7E CACE
uid                      Anthropic Claude Code Release Signing <security@anthropic.com>
```

Si la huella no coincide, **borrar el archivo** y no continuar:

```bash
sudo rm /usr/share/keyrings/claude-desktop-archive-keyring.asc
```

Si aún no está instalado el programa:

```bash
sudo apt install claude-desktop
```

Verificado el 2026-10-28: la llave publicada en `key.asc` tiene esa huella.

---

## 5. Solución B — No se usa Claude Desktop: quitar el repo (la que aplica aquí)

```bash
sudo rm /etc/apt/sources.list.d/claude-desktop.list
sudo apt update
```

---

## 6. Diagnóstico rápido (para la próxima vez)

Si `sqv` devuelve `Failed to parse keyring ... No such file or directory`:

```bash
# ¿Qué llavero declara el repo?
grep -r "dominio-del-repo" /etc/apt/sources.list /etc/apt/sources.list.d/

# ¿Existe el archivo?
ls -la /ruta/del/llavero
```

- **Archivo no existe** → este documento: descargar el llavero oficial y verificar huella.
- **`Missing key` / `EXPKEYSIG`** (llave rotada o vencida) → ver [github-cli-apt-key-expirada.md](github-cli-apt-key-expirada.md).

---

*Documentado el 2026-10-28.*
