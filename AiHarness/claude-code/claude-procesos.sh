#!/usr/bin/env bash
# Lista legible de los procesos de Claude Code (extensión de VS Code).
# Uso: ./claude-procesos.sh
printf "%-8s %-14s %-6s %-8s %-11s %s\n" PID "ABIERTO HACE" CPU "RAM(MB)" ESTADO CARPETA
for p in $(pgrep -f '[n]ative-binary/claude'); do
  [ -d /proc/$p ] || continue
  et=$(ps -o etimes= -p "$p" | tr -d ' ')
  d=$((et/86400)); h=$((et%86400/3600)); m=$((et%3600/60))
  if [ $d -gt 0 ]; then t="${d}d ${h}h"; elif [ $h -gt 0 ]; then t="${h}h ${m}m"; else t="${m}m"; fi
  cpu=$(ps -o %cpu= -p "$p" | tr -d ' ')
  ram=$(( $(ps -o rss= -p "$p" | tr -d ' ') / 1024 ))
  if [ "$(pgrep -P "$p" | wc -l)" -gt 0 ]; then st="EJECUTANDO"; else st="en espera"; fi
  printf "%-8s %-14s %-6s %-8s %-11s %s\n" "$p" "$t" "${cpu}%" "$ram" "$st" "$(readlink /proc/$p/cwd | sed "s|^$HOME|~|")"
done
