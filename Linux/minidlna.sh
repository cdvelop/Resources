#!/bin/bash
# Script para iniciar MiniDLNA en primer plano y detenerlo al cerrar la terminal

# Opcional: fuerza reescaneo
minidlnad -R

# Inicia MiniDLNA en primer plano (no como demonio)
exec minidlnad -f /etc/minidlna.conf -d
