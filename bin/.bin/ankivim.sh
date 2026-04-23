#!/usr/bin/env bash

search_dir="$HOME/.ankivim/decks"

# Garante que o diretório existe
mkdir -p "$search_dir"

# Lista apenas os nomes das pastas (decks) e passa para o dmenu
selection=$(find "$search_dir" -maxdepth 1 -mindepth 1 -type f -printf "%f\n" | rofi -dmenu -i -p "Selecionar Deck:")

# Sai se nada for selecionado
[ -z "$selection" ] && exit

foot -a ankivim -e anki_parser.py "$selection"
