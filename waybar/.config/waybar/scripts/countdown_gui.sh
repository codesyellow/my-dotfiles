#!/usr/bin/env bash

SAIDA=$(yad --title="yad_countdown" --form \
  --field="Time (min):SCL" "5!1..120!1" \
  --field="Repetitions:NUM" "1!1..10!1" \
  --button="Start:0" --button="Cancel:1")

if [ $? -eq 0 ]; then
  TIME=$(echo $SAIDA | cut -d'|' -f1)
  REPS=$(echo $SAIDA | cut -d'|' -f2)

  setsid $HOME/.config/waybar/scripts/countdown.py -t "$TIME" -r "$REPS" &
fi
