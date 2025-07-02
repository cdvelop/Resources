# Revisión y Reparación del Disco en Windows

Este documento explica cómo usar dos comandos de Windows para revisar y reparar el disco.

## 1. CHKDSK

El comando:

```
chkdsk C: /f /x
```

- Revisa la unidad C: en busca de errores.
- La opción `/f` repara automáticamente cualquier fallo detectado.
- La opción `/x` força el desmontaje del disco si es necesario para terminar el proceso.

Después de ejecutar este comando, se recomienda reiniciar el ordenador para que las correcciones surtan efecto.

## 2. CHKNTFS

El comando:

```
CHKNTFS /X C:
```

- Evita que Windows programe una comprobación del sistema de archivos en la unidad C: durante el próximo arranque.

Este paso puede ser útil si quieres impedir una verificación automática innecesaria luego de realizar una reparación.
