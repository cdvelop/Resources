# Diferencia entre FROM scratch y FROM distroless

La diferencia principal entre crear un Dockerfile con FROM scratch y FROM distroless radica en el tamaño y la seguridad de la imagen final.

## FROM scratch

- **Tamaño**: La imagen resultante será extremadamente pequeña, ya que no incluye ningún sistema operativo o biblioteca preinstalada.
- **Seguridad**: El tamaño mínimo y la falta de dependencias externas reducen el riesgo de vulnerabilidades.
- **Complejidad**: La construcción de la imagen requiere que se incluyan manualmente todos los componentes necesarios, incluyendo el sistema operativo, las bibliotecas y las dependencias.
- **Uso**: Ideal para imágenes de microservicios muy pequeñas, aplicaciones minimalistas o herramientas de línea de comandos que no requieren dependencias del sistema operativo.

## FROM distroless

- **Tamaño**: Las imágenes Distroless son más grandes que las creadas con FROM scratch, pero siguen siendo considerablemente más pequeñas que las imágenes basadas en distribuciones completas como Ubuntu o Debian.
- **Seguridad**: Distroless elimina componentes innecesarios del sistema operativo y minimiza las bibliotecas y las dependencias, lo que reduce el riesgo de vulnerabilidades.
- **Complejidad**: La construcción de la imagen es más fácil que con FROM scratch ya que Distroless proporciona un sistema operativo base con algunas bibliotecas esenciales.
- **Uso**: Ideal para aplicaciones de producción donde se necesita un tamaño de imagen mínimo y una seguridad mejorada, sin necesidad de la complejidad de FROM scratch.

## Resumen

- FROM scratch proporciona un entorno completamente personalizado con el mínimo tamaño, pero requiere una configuración manual completa.
- FROM distroless ofrece una base de sistema operativo segura y pequeña, que simplifica la construcción de imágenes.

# MAS INFO:
https://www.youtube.com/watch?v=PT35LycAqTw&list=PLQhxXeq1oc2mB6_KY-l_zgWJWZo_ne9MZ&index=4

https://github.com/GoogleContainerTools/distroless