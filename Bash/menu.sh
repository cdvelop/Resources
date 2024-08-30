#!/bin/bash

# Definir las opciones del menú
options=("Opción 1" "Opción 2" "Opción 3" "Salir")

# Función para mostrar el menú
show_menu() {
    echo "Selecciona una opción:"
    select opt in "${options[@]}"; do
        case $opt in
            "Opción 1")
                echo "Has seleccionado Opción 1"
                ;;
            "Opción 2")
                echo "Has seleccionado Opción 2"
                ;;
            "Opción 3")
                echo "Has seleccionado Opción 3"
                ;;
            "Salir")
                echo "Saliendo..."
                break
                ;;
            *)
                echo "Opción inválida"
                ;;
        esac
    done
}

# Llamar a la función para mostrar el menú
show_menu
