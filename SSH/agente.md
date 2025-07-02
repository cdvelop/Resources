# verificar si el agente ssh tiene una clave guardada
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