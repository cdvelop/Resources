# Desinstalar Ollama y sus modelos (Debian 13)

Pasos para eliminar por completo la instalación de Ollama hecha con el
instalador oficial (`curl -fsSL https://ollama.com/install.sh | sh`), que
en esta máquina dejó:

| Qué | Dónde | Tamaño |
|---|---|---|
| Binario | `/usr/local/bin/ollama` | 43 MB |
| Librerías (CUDA/ROCm bundladas) | `/usr/local/lib/ollama/` | 4.7 GB |
| Modelos descargados (blobs) | `/usr/share/ollama/.ollama/` | 13 GB |
| Servicio systemd | `/etc/systemd/system/ollama.service` | — |
| Usuario/grupo de sistema | `ollama` (uid 995, gid 993) | — |
| Config del usuario actual | `~/.ollama/` (`config.json`, `history`) | 12 KB |

Total a liberar: ~**18 GB**.

## 1. Detener y deshabilitar el servicio

```bash
sudo systemctl stop ollama
sudo systemctl disable ollama
```

## 2. Eliminar el servicio systemd

```bash
sudo rm /etc/systemd/system/ollama.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

## 3. Eliminar el binario y las librerías

```bash
sudo rm /usr/local/bin/ollama
sudo rm -rf /usr/local/lib/ollama
```

## 4. Eliminar los modelos y datos del servicio (la parte grande: 13 GB)

```bash
sudo rm -rf /usr/share/ollama
```

Esto borra `/usr/share/ollama/.ollama/{blobs,manifests}`, es decir, todos
los modelos descargados.

## 5. Eliminar el usuario y grupo de sistema `ollama`

El instalador crea un usuario de sistema dedicado (`ollama`, sin login,
`/bin/false`) que ya no hace falta:

```bash
sudo userdel ollama
sudo gpasswd -d "$USER" ollama
sudo groupdel ollama
```

> Nota: tu propio usuario (`cesar`) estaba agregado como miembro
> secundario del grupo `ollama` (para poder acceder a la GPU vía los
> grupos `video`/`render` que comparte el servicio). `groupdel` **rehúsa
> borrar un grupo que todavía tiene miembros** — por eso falla con
> `group ollama not removed because it has other members` si se intenta
> antes de sacar a `cesar` del grupo con `gpasswd -d`. `userdel ollama` sí
> se completa igual aunque el grupo quede pendiente.

## 6. Limpiar la config del usuario actual (opcional, poco espacio)

```bash
rm -rf ~/.ollama
```

Solo contiene `config.json` e `history` de la CLI (unos 12 KB) — no hay
modelos ahí, pero conviene borrarlo para no dejar rastros.

## 7. Verificar que no quedó nada

```bash
which ollama                                  # no debe encontrar nada
systemctl status ollama 2>&1 | head -3        # "could not be found"
id ollama 2>&1                                # "no such user"
ls /usr/share/ollama /usr/local/lib/ollama 2>&1   # "No such file or directory"
df -h ~                                       # confirmar espacio liberado
```
