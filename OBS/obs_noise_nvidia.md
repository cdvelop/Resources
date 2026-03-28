# Eliminación de Ruido NVIDIA (NVIDIA Broadcast) en OBS para Linux

Si provienes de Windows o ves tutoriales en internet, probablemente escuches mil maravillas del filtro nativo de **NVIDIA Noise Removal** (impulsado por IA a través de NVIDIA Broadcast / NVIDIA Audio Effects SDK). Es, con diferencia, el mejor supresor de ruido del mercado.

**El Problema en Linux (Debian 12):**
Lamentablemente, **NO ES POSIBLE descargar ni instalar el filtro nativo de Eliminación de Ruido de NVIDIA para que aparezca dentro de OBS Studio en Linux**.

**¿Por qué pasa esto si tienes una NVIDIA RTX 3060?**
Aunque NVIDIA ofrece un soporte excelente para los drivers gráficos y los codificadores de video (como el NVENC H.264 que configuraste previamente) en Linux; el software avanzado de audio y filtros de cámara (**NVIDIA Broadcast** y sus SDKs asociados) es de **algoritmo propietario y exclusivo para el ecosistema Windows**. NVIDIA, hasta la fecha, no ha liberado oficialmente un puerto ni un plugin decodificado para que OBS Studio en Linux se integre directamente con los Tensor Cores de tu RTX para el filtrado de audio.

---

## Alternativas Viables para Grabar sin Ruido en Debian 12

Puesto que no tendrás el botón mágico de "NVIDIA Noise Removal" en las opciones de Filtros de tu micrófono en OBS, tienes dos caminos que tomar para lograr un nivel de silencio profesional:

### Nivel 1: Filtros Integrados de OBS (Recomendado para empezar)
OBS Studio viene con dos opciones preinstaladas en Linux que, si se configuran bien, dan resultados sobresalientes:

1.  **RNNoise (Mejor Calidad / Basado en IA)**:
    - Ve a tu micrófono en OBS > Clic en los 3 puntitos > *Filtros*.
    - Añeta un filtro de *Eliminación de ruido (Noise Suppression)*.
    - Selecciona **RNNoise**.
    - *¿Qué es?* Es una red neuronal de código abierto entrenada para distinguir la voz del ruido. Funciona muy similar a NVIDIA Broadcast pero usando el procesador (CPU). Como tu i7-11800H es muy potente (8 núcleos/16 hilos), no notarás ningún impacto negativo en el rendimiento al usarlo.
2.  **Speex (Bajo uso de CPU)**:
    - El otro filtro tradicional preinstalado. Debes configurarlo manualmente bajando o subiendo los decibelios, pero requiere más tiempo ajustarlo para que no mutile la voz humana. Quédate con RNNoise de preferencia.

### Nivel 2: Soluciones a Nivel Sistema Operativo (Usuarios Avanzados)
Si RNNoise de OBS no te convence y quieres aislar completamente los clics del teclado o los perros ladrando a nivel de tu sistema operativo (que también limpie el audio de tus reuniones en Discord/Google Meet por fuera de OBS), existen alternativas open-source muy poderosas que imitan el comportamiento de NVIDIA Broadcast:

1.  **NoiseTorch (Fácil)**:
    - Es una pequeña aplicación visual que crea un "micrófono virtual" en Debian que aplica directamente un algoritmo de supresión de ruido (RNNoise modificado) antes de que el sonido siquiera llegue a OBS.
    - [Repositorio de NoiseTorch en GitHub](https://github.com/noisetorch/NoiseTorch)
2.  **EasyEffects via PipeWire (Profesional)**:
    - Si tu Debian 12 está usando *PipeWire* como servidor de audio (el estándar de facto moderno en Linux), puedes instalar el programa **EasyEffects** (desde tu centro de software o APT).
    - Este programa es un estudio de sonido completo donde puedes aplicar supresores de ruido avanzados (como *DeepFilterNet*), ecualizadores, de-essers y puertas de ruido que rivalizan directamente con herramientas de nivel de estudio. Todo esto sin depender de los drivers privativos de NVIDIA para audio.

**Resumen:** No pierdas el tiempo buscando tutoriales para instalar NVIDIA Noise Removal en Debian. Para tus cursos de programación, usa el filtro **RNNoise** integrado en OBS Studio; es de código abierto, usa Inteligencia Artificial y cumple maravillosamente la función de anular el ruido de fondo y los teclazos con cero configuraciones complejas.

---

## Puerta de Ruido (Noise Gate): Cómo evitar sonidos lejanos

Si tu objetivo principal es **evitar ruidos externos que ocurren a 1 o 2 metros de distancia** (perros ladrando, coches, gente hablando en otra habitación) y estás usando un **micrófono de solapa**, la herramienta perfecta que DEBES usar en combinación con RNNoise es la **Puerta de Ruido (Noise Gate)**.

### ¿Cómo funciona exactamente una Puerta de Ruido?
Imagina una puerta física en una habitación. 
- Si empujas la puerta suavemente, no se abre (el sonido se bloquea).
- Si la empujas con fuerza suficiente, la puerta se abre de par en par (el sonido pasa).

La Puerta de Ruido en OBS hace exactamente esto basado en el **volumen** (los decibelios, dB). Su trabajo NO es "limpiar" el audio mágicamente como la Inteligencia Artificial (eso lo hace RNNoise). Su único trabajo es **cortar el micrófono (mutearlo) por completo cuando no estás hablando**, y **abrirlo solo cuando detecta tu voz fuerte y cercana**.

Como tienes un **micrófono de solapa (corbatero)**, este está pegado a tu pecho o cuello. Tu voz entra extremadamente fuerte al micrófono. Sin embargo, un perro ladrando a 2 metros, o un coche en la calle a 10 metros, suenan mucho más bajo (con menos volumen) al llegar a ese micrófono. La Puerta de Ruido usará esa diferencia de volumen a tu favor.

### Explicación de los Ajustes (Según tu captura)

En tu captura de pantalla, tienes los siguientes valores. Así es como debes interpretarlos para configurarlos para tu curso:

1.  **Umbral de Apertura (Open Threshold) [-26 dB]**:
    - **Qué significa:** Es la "fuerza mínima" necesaria para abrir la puerta. 
    - **Cómo usarlo:** Al empezar a hablar con tu tono de voz normal de instructor, tu voz superará los -26 dB. OBS entonces "encenderá" el micrófono y te escuchará. Si un perro ladra a 2 metros, el ladrido llegará tal vez a -35 dB (más bajo que -26 dB), por lo que la puerta "no se abrirá" y el ladrido quedará **totalmente bloqueado** y no aparecerá en tu grabación.
    - *Ajuste ideal para ti:* Habla al micrófono de solapa y mira la barra de volumen verde de OBS. Fíjate hasta qué número llega tu voz normalmente. Pon el Umbral de Apertura unos dB *por debajo* de tu voz normal, para asegurarte de que la puerta siempre se abra cuando tú hables, pero quede por encima del ruido ambiental lejano.

2.  **Umbral de Cierre (Close Threshold) [-62 dB]**:
    - **Qué significa:** Cuándo cerrar la puerta después de que dejes de hablar.
    - **Cómo usarlo:** Si dejas de hablar, el piso de ruido de tu habitación (ventiladores, la calle) bajará. Cuando el volumen baje de -62 dB, OBS muteará de nuevo el micrófono.
    - *Ajuste ideal para ti:* Generalmente el umbral de cierre se coloca unos **5 a 10 dB por debajo del Umbral de Apertura**. El valor de -62 dB que tienes está exageradamente distanciado de tu apertura (-26 dB). Si lo dejas en -62 dB, la puerta tardará demasiado en cerrarse, dejando pasar ruidos entre tus frases. Te sugiero cambiar este valor a unos **-32 dB o -35 dB**.

### Los Tiempos (Attack, Hold, Release)
Afectan *qué tan rápido* se abre y se cierra la puerta. Los valores que tienes (25ms, 200ms, 150ms) son los **valores por defecto de OBS y son excelentes para la voz hablada en un curso**. No necesitas modificarlos.

- **Attack Time (25 ms):** La puerta se abre súper rápido casi instantáneamente (25 milisegundos) cuando hablas, para no cortar la primera letra de tu palabra.
- **Hold Time (200 ms):** Si haces una pequeñísima pausa entre palabras, la puerta se "sostiene" abierta 200 milisegundos antes de intentar cerrarse, evitando que el audio se corte a tropezones.
- **Release Time (150 ms):** Cuando terminas la frase, la puerta se cierra gradualmente en 150 ms (como un suavizado), en lugar de dar un "corte brusco" (mute) desagradable.

**El Combo Perfecto para tu Curso:**
Coloca **primero** el filtro *"Noise Suppression" (RNNoise)* en la lista para que la IA limpie los ruidos constantes (como ventiladores). Y debajo, coloca tu **"Noise Gate"** con el Umbral de Apertura (Open) configurado al volumen de tu voz cantada hacia tu micrófono de solapa, y el Umbral de Cierre (Close) unos 5-8 dB más bajo. ¡Tu audio quedará con calidad de estudio y 100% libre de vecinos o ladridos lejanos!
