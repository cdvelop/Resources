# Whisper CPP

Whisper.cpp es una implementación en C++ del modelo de reconocimiento de voz Whisper desarrollado por OpenAI. Permite transcribir audio a texto de forma eficiente y precisa utilizando el poder de las redes neuronales. Esta biblioteca de código abierto facilita la integración de capacidades de transcripción de voz en aplicaciones y sistemas basados en C++.


[Repositorio de Whisper C++](https://github.com/ggerganov/whisper.cpp)



### Instalación whisper.cpp en Windows 10

Requisitos Previos
- [Asegúrate de tener Git instalado](https://git-scm.com/download/win).
- Necesitarás Herramientas para compilar C++ ej: [TDM-GCC-64](https://jmeubank.github.io/tdm-gcc/download/)


1. Abre una terminal (Git Bash) y clona el repositorio de Whisper C++ en donde prefieras:

```sh
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
```
2. Crea un directorio de construcción y configura el proyecto para usar TDM-GCC:

```sh
mkdir build
cd build
cmake .. -G "MinGW Makefiles" -DCMAKE_SH="CMAKE_SH-NOTFOUND"
```
- La opción -DCMAKE_SH="CMAKE_SH-NOTFOUND" evita problemas que pueden surgir si CMake intenta usar una shell de Unix en lugar de la de Windows.

3. Compila el proyecto :

```sh
mingw32-make
```
- mingw32-make es una herramienta de construcción similar a make, pero diseñada para ser utilizada en entornos de Windows. Forma parte del conjunto de herramientas MinGW (Minimalist GNU for Windows) y se utiliza para automatizar el proceso de construcción de proyectos software, específicamente aquellos que utilizan el sistema de compilación GNU

4. tus archivos de salida se encuentran en el directorio build/bin