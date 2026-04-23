#!/bin/bash

function check_dependencies() {
  local ret=0
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      notify-send 'run copy_window_title.sh to see the error message'
      echo "Missing dependency: $cmd."
      ret=1
    fi
  done
  return $ret
}

(check_dependencies "niri" "wl-copy") || exit 1

WINDOW_TITLE=$(niri msg focused-window | grep "Title:" | sed -E 's/.*Title: "(.*)"/\1/')

if [ -n "$WINDOW_TITLE" ]; then
    echo -n "$WINDOW_TITLE" | wl-copy
    
    notify-send "Title Copied" "The window title '$WINDOW_TITLE' is now in your clipboard." --icon=edit-copy
else
    notify-send "Error" "Could not retrieve the window title." --severity=critical
fi
