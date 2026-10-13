# GitHub CLI (`gh`) — llave APT expirada / "Missing key" — Debian 13

Error que aparece al ejecutar `sudo apt update` cuando la llave GPG del repositorio
de GitHub CLI quedó obsoleta.

---

## 1. Síntoma

```text
Warning: An error occurred during the signature verification. The repository is not updated
and the previous index files will be used. OpenPGP signature verification failed:
https://cli.github.com/packages stable InRelease: Sub-process /usr/bin/sqv returned an error
code (1), error message is: Missing key 7F38BBB59D064DBCB3D84D725612B36462313325, which is
needed to verify signature.
Warning: Failed to fetch https://cli.github.com/packages/dists/stable/InRelease ...
Warning: Some index files failed to download. They have been ignored, or old ones used instead.
```

El resto de los repositorios (Debian, Brave, etc.) se actualizan normalmente; solo falla `cli.github.com`.

---

## 2. Causa

GitHub **rotó la llave de firma** de su repositorio APT:

| Llave | Huella (fingerprint) | Creada | Vence |
|---|---|---|---|
| Vieja | `2C61 0620 1985 B60E 6C7A C873 23F3 D4EA 7571 6059` | 2022-09-06 | **2026-09-05** (expirada) |
| Nueva | `7F38 BBB5 9D06 4DBC B3D8 4D72 5612 B364 6231 3325` | 2026-04-07 | — |

El repositorio ahora firma con la llave nueva, pero el llavero local
(`/usr/share/keyrings/githubcli-archive-keyring.gpg`, instalado en julio 2025)
solo contiene la vieja. Debian 13 verifica firmas con `sqv` (Sequoia), que
rechaza el `InRelease` porque no encuentra la llave `7F38…3325`.

Configuración del repo en este equipo:

```text
/etc/apt/sources.list.d/github-cli.list
deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main
```

---

## 3. ¿Es grave?

**No es un problema de seguridad**; es al revés: APT está haciendo su trabajo y se niega a
confiar en algo que no puede verificar.

Consecuencias reales:

- `gh` **deja de recibir actualizaciones** (queda en la versión instalada).
- APT usa el índice viejo de ese repo; el resto del sistema se actualiza normal.
- El `apt upgrade` **no instala nada** de ese repo sin verificar.

Lo que **NO** hay que hacer:

- ❌ `trusted=yes` en el `.list`
- ❌ `--allow-unauthenticated` / `--allow-insecure-repositories`
- ❌ Importar la llave desde un keyserver cualquiera sin comparar la huella

---

## 4. Solución

Reemplazar el llavero por el oficial actual (que ya incluye la llave nueva):

```bash
# 1. Descargar el llavero oficial a un archivo temporal
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /tmp/githubcli.gpg

# 2. Verificar que contiene la huella nueva 7F38 BBB5 ... 6231 3325
gpg --show-keys --with-fingerprint /tmp/githubcli.gpg

# 3. Instalarlo en la ruta que usa signed-by
sudo install -m 0644 /tmp/githubcli.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
rm /tmp/githubcli.gpg

# 4. Probar
sudo apt update
```

En el paso 2 la salida debe incluir:

```text
pub   rsa4096 2026-04-07 [SC]
      7F38 BBB5 9D06 4DBC B3D8  4D72 5612 B364 6231 3325
uid                      GitHub CLI <opensource+cli@github.com>
```

> Si aparece también la llave vieja `2C61…6059` marcada `[expired]` y el aviso
> `gpg: WARNING: No valid encryption subkey left over.`, es normal: el llavero
> oficial trae ambas por compatibilidad. APT usa la vigente.

Después, `sudo apt upgrade` actualizará `gh` si hay versión nueva. Verificar con:

```bash
gh --version
```

---

## 5. Diagnóstico rápido (para la próxima vez)

Si vuelve a aparecer un `Missing key` o `EXPKEYSIG` con **cualquier** repo de terceros:

```bash
# ¿Qué archivo define el repo y qué llavero usa?
grep -r "dominio-del-repo" /etc/apt/sources.list /etc/apt/sources.list.d/

# ¿Qué llaves tiene ese llavero y cuándo vencen?
gpg --show-keys --with-fingerprint /ruta/del/llavero.gpg
```

Si la huella que pide APT no está en el llavero, o la que está aparece `[expired]`,
la solución es la misma: descargar el llavero **desde el sitio oficial del proveedor**,
comparar la huella con la que pide el error y reemplazarlo.

Referencia oficial de instalación: <https://github.com/cli/cli/blob/trunk/docs/install_linux.md>

---

*Documentado el 2026-10-13.*
