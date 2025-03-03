## al intentar ejecutar un comando con la cli de github Te aparece este error: 

```bash	
error refreshing credentials for OLDER_USER_NAME, received credentials for NEW_USER_NAME, did you use the correct account in the browser?
```	
Este error ocurre porque gh está autenticado con la cuenta incorrecta. Para solucionarlo, debes cerrar sesión en gh y volver a iniciar sesión con la cuenta correcta. Sigue estos pasos:

```bash	
# Cerrar sesión en gh
gh auth logout

# iniciar sesión con la cuenta correcta
gh auth login

# verificar que la cuenta correcta esté autenticada
gh auth status
```

## me aparecen dos cuentas en la lista de cuentas autenticadas, ¿cómo puedo eliminar una de ellas?

```bash
# 1 Listar cuentas autenticadas
gh auth status

# 2 elegir la cuenta a quitar del login con:
gh auth logout --hostname github.com


# ahora deberías tener una sola cuenta autenticada
gh auth status

```

## Si aún ves ambas cuentas, prueba eliminar manualmente la configuración almacenada en tu sistema:
```bash
rm -rf ~/.config/gh
gh auth login  # Vuelve a iniciar sesión con la cuenta correcta
```