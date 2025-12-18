# Configuración Visual de Bash

## Prompt Minimalista (Solo Ruta con Color)

Esta configuración modifica el prompt de la terminal para ocultar el `usuario@host` y mostrar solamente la ruta actual en color azul, manteniendo un estilo limpio.

### 1. Prueba Temporal

Para probar cómo se ve sin modificar nada permanentemente, ejecuta:

```bash
export PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '
```

- `\[\033[01;34m\]`: Activa el color **Azul brillante**.
- `\w`: Muestra la **ruta actual**.
- `\[\033[00m\]`: **Resetea** el color.

### 2. Configuración Permanente

Para hacer este cambio permanente:

1.  Abre tu archivo de configuración:
    ```bash
    nano ~/.bashrc
    ```

2.  Busca el bloque que configura `PS1` (generalmente dentro de un `if [ "$color_prompt" = yes ]; then`).

3.  Reemplaza el bloque `if/else` correspondiente con lo siguiente:

    ```bash
    if [ "$color_prompt" = yes ]; then
        # Solo ruta en color azul brillante
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        # Solo ruta sin color
        PS1='${debian_chroot:+($debian_chroot)}\w\$ '
    fi
    ```

4.  Guarda los cambios (`Ctrl+O`, `Enter`) y sal (`Ctrl+X`).

5.  Recarga la configuración:
    ```bash
    source ~/.bashrc
    ```
