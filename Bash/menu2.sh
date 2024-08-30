#!/bin/bash

# Definir las opciones del menú
options=("Opción 1" "Opción 2" "Opción 3" "Salir")
current_index=0

# Función para mostrar el menú
show_menu() {
    clear
    for i in "${!options[@]}"; do
        if [ $i -eq $current_index ]; then
            echo "➜ ${options[$i]}"
        else
            echo "  ${options[$i]}"
        fi
    done
}

# Función para manejar la navegación por el menú
navigate_menu() {
    case $1 in
        up)
            ((current_index--))
            if [ $current_index -lt 0 ]; then
                current_index=$((${#options[@]} - 1))
            fi
            ;;
        down)
            ((current_index++))
            if [ $current_index -ge ${#options[@]} ]; then
                current_index=0
            fi
            ;;
        select)
            case $current_index in
                0)
                    echo "Has seleccionado Opción 1"
                    ;;
                1)
                    echo "Has seleccionado Opción 2"
                    ;;
                2)
                    echo "Has seleccionado Opción 3"
                    ;;
                3)
                    echo "Saliendo..."
                    exit 0
                    ;;
            esac
            ;;
    esac
}

# Bucle principal de la consola interactiva
while true; do
    show_menu
    read -s -n1 key
    case $key in
        A|a) navigate_menu up;;
        B|b) navigate_menu down;;
        " ") navigate_menu select;;
    esac
done