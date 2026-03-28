# SSH Agent - Gestión de claves

## Debian 13+ / Linux — keychain (solución persistente)

Al actualizar a Debian 13, `gnome-keyring` dejó de manejar SSH automáticamente.
`keychain` cachea la passphrase una sola vez por boot.

### Instalación
```bash
sudo apt install keychain
```

### Configurar en ~/.bashrc (se ejecuta en cada terminal)
```bash
eval $(keychain --eval --agents ssh --quiet id_rsa)
```

### Cargar la clave por primera vez (pide passphrase una sola vez)
```bash
keychain ~/.ssh/id_rsa
```

Después del reboot, la primera terminal que abras pedirá la passphrase.
Las siguientes terminales (incluyendo VSCode) la reutilizan sin pedirla.

### Verificar que la clave está cargada
```bash
ssh-add -l
ssh -T git@github.com
```

---

## Verificar si el agente ssh tiene una clave guardada
ssh-add -l

# si el comando muestra algo como:
```bash
256 SHA256:XXXXXXX/XXXXXXX... YOUR_MAIL@YOUR_DOMAIN.com (ED25519)
```
- significa que hay una clave guardada

- si el comando muestra
```bash
The agent has no identities.
```
- significa que no hay claves guardadas en powershell ejecuta
```bash
ssh-add C:\Users\YOUR_WINDOWS_USER_NAME\.ssh\id_rsa
```
- para agregar la clave