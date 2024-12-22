# políticas de reinicio de docker
Las políticas de reinicio de Docker son configuraciones que determinan cómo los contenedores deben comportarse cuando se detienen o fallan. Estas políticas son:

1. no: No reinicia el contenedor automáticamente (política predeterminada).
2. on-failure[:max-retries]: Reinicia el contenedor si se detiene con un código de salida distinto de cero.
3. always: Siempre reinicia el contenedor si se detiene.
4. unless-stopped: Similar a 'always', pero no reinicia si el contenedor fue detenido manualmente.

Para configurar una política de reinicio, se usa la opción --restart al ejecutar docker run:


docker run --restart=always mi-imagen


También se puede modificar la política de un contenedor existente con:


docker update --restart=on-failure:3 mi-contenedor


Estas políticas son útiles para garantizar la disponibilidad de servicios críticos y manejar fallos inesperados en los contenedores.
