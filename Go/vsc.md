# Go

### para que aparezca logs en test de golang en visual studio hay que añadir a la configuración
```json
"go.testFlags": ["-v"]
```

Para ver los tests con colores en la salida de output en Visual Studio Code cuando ejecutas pruebas de Go, puedes agregar la bandera `-test.v` a tu configuración. Esta bandera habilita el modo detallado y colorizado para los tests de Go.

Aquí te muestro cómo puedes modificar tu configuración actual para incluir esta opción:

```json
"go.testFlags": [
    "-v",
    "-failfast",
    "-test.v"
    // ... tus otras banderas ...
],
```

Agregando `-test.v` a tu lista de banderas, deberías ver la salida de los tests con colores en la ventana de output de VS Code.

Además, si quieres asegurarte de que siempre se use el color en la salida, incluso cuando se redirecciona a un archivo o a través de una tubería, puedes agregar la variable de entorno `GOTEST_COLOR=always`. Puedes hacer esto en la configuración de VS Code de la siguiente manera:

```json
"go.testEnvVars": {
    "GOTEST_COLOR": "always"
},
```

Esta configuración forzará el uso de colores en la salida de los tests de Go.

¿Te gustaría que te explique más sobre alguna de estas opciones o sobre cómo funcionan los colores en los tests de Go?