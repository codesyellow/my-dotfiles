#!/bin/bash

# Directory to search for files
search_dir="$HOME/.ankivim/decks"

# Prompt user to enter a file name using dmenu
file_path=$(find "$search_dir" -type f | sed "s|$search_dir/||" | dmenu -nb "#2e3440" -z "800" -x "230" -y "0" -sb "#2e3440" -shb "#2e3440" -fn "JetBrainMono Nerd Font:size=14" -p "")

# If user pressed escape or canceled, exit
[ -z "$file_path" ] && exit

# Extract the directory name from the selected file path
dir_name=$(dirname "$file_path")

# Check if the directory exists
if [ -d "$search_dir/$dir_name" ]; then
  # Directory exists, open it with a specific software (e.g., nautilus)
  st -t 'anki-vim' -e anki-vim "$search_dir/$dir_name"
else
  # Directory does not exist, create it and then open with a specific software
  mkdir -p "$search_dir/$dir_name"
  st -t 'anki-vim' -e anki-vim "$search_dir/$dir_name"
fi
