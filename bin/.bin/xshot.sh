#!/usr/bin/env bash

PIC_PATH="$HOME/.pictures"
mkdir -p "$PIC_PATH"

DATE="$(date +'%Y%m%d%H%M%S')"
OUT="$PIC_PATH/ps_$DATE.png"

case "$1" in
  screen)
    sleep 1
    flameshot screen -p "$OUT" 
    ;;

  region|edit)
    flameshot gui -p "$OUT"
    ;;
esac
