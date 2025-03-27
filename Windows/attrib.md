# Comando ATTRIB en Windows

El siguiente comando elimina los atributos de solo lectura, oculto y sistema de **todos** los archivos y directorios en la unidad F: de manera recursiva:

```
F:\>attrib /d /s -r -h -s *.*
```

## Desglose del comando

- **attrib**: Utilidad para ver y modificar atributos de archivos y directorios.
- **/d**: Aplica los cambios también a los directorios.
- **/s**: Ejecuta el comando de forma recursiva en todos los archivos y subdirectorios.
- **-r -h -s**: Elimina respectivamente los atributos:
    - **r**: Solo lectura (read-only).
    - **h**: Oculto (hidden).
    - **s**: Sistema (system).
- **\*.\***: Comodín que selecciona todos los archivos y carpetas del directorio actual.

**Resumen**: Este comando recorre la unidad F: eliminando recursivamente los atributos de solo lectura, oculto y sistema, lo cual es útil para modificar archivos que estaban protegidos.