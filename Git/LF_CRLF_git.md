Lo que hace esa opción es indicar si quieres que en el repositorio se guarden los saltos de línea de los ficheros en formato Unix (LF) pese a tener tus ficheros en tu entorno local con saltos de línea al formato Windows (CRLF).

Para el que no sepa esto de LF y CRLF, recuerdo que los ficheros de texto tienen que señalar de alguna manera los saltos de línea. Históricamente, en sistemas basados en DOS/Windows las líneas de los ficheros de texto acaban con dos caracteres: CR (Carriage return) y LF (Line feed) que sería el equivalente a los movimientos que se hacen en una máquina de escribir cuando acabamos de escribir una línea. En sistemas basados en Unix, por contra, los ficheros de texto delimitan las líneas únicamente con el caracter LF.

En git esto puede ser un problema, si usuarios utilizan editores/sistemas operativos que generan ficheros de texto con finales de línea diferentes. Por ejemplo si tú creas un fichero en Linux con todas las líneas acabando en LF, y un un compañero edita ese fichero en Windows y añade una línea que acaba en CRLF, cuando recibas los cambios de tu compañero verás un caracter extra "basura" en tu editor.

Para evitar esto, git tiene esta funcionalidad (core.autocrlf) que se encarga de convertir los saltos de línea a LF en todos los ficheros de texto del respositorio.

Esa opción la puedes configurar de varias formas:

core.autocrlf = true: Cuando commitees, tus ficheros se transformarán automáticamente a LF, y cuando hagas checkout de un fichero, se convertirá automáticamente a CRLF

core.autocrlf = input: Cuando comitees, tus ficheros se transformarán automáticamente a LF, pero cuando hagas checkout, recibirás el fichero sin modificación de como esté en el repositorio.

core.autocrlf = false: No se hará ningún cambio a los finales de línea de los ficheros de texto.

En tu caso, el mensaje de advertencia te está dando porque tienes puesta la primera opción (core.autocrlf = true).

Esta advertencia te puede estar pasando porque estás guardando los ficheros con saltos de línea LF desde Windows y git no se espera que los guardes de esa manera. Por lo que cuando vuelvas a hacer checkout de los ficheros, te los va a convertir el CRLF y los vas a ver mal en el editor.

Una vez entendido por qué te da esa advertencia, para evitar que te vuelva a salir, puedes:

O bien cambiar en tu editor de texto la configuración para que guarde los saltos de línea con CRLF,
o bien cambiar las opciones de configuración de git a input o false.
Esto es decisión tuya y estaría bien que lo pusieses en consenso con quien use además de ti ese repositorio.

Me he ayudado de esta publicación para escribir la respuesta: git replacing LF with CRLF por si tienes más dudas está muy bien explicado aunque en perfecto inglés. Incluye los comandos que hay que ejecutar por si quieres cambiar esa opción de configuración.

EDIT: Para cambiar los saltos de línea en Notepad++ haz doble click en la opción que aparece en la esquina inferior derecha de la ventana: