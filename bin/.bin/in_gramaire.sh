#!/usr/bin/env bash

# check if current window name = a name that exist inside Gramaire\ Gamer.md file
FILE_PATH="$HOME/.vimwiki/Gramaire Gamer.md"
#WINDOW_TITLE=$(niri msg focused-window | grep "Title:" | sed -E 's/.*Title: "(.*)"/\1/')
WINDOW_TITLE="Styx"

if grep -q "$WINDOW_TITLE" "$FILE_PATH"; then
  echo "Yes"
else
  echo "No"
fi
# if name exist, go to the file using the server command in vim, else, just open index.md file if there's not an history file with content.
# if there's a history file with the last content that was opened before, restore to that file insted of going to index.md


echo "$WINDOW_TITLE"
