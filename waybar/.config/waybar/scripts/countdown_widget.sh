#!/usr/bin/env bash

FILE_TIME="/tmp/countdown_time"
FILE_HALF="/tmp/countdown_half"
FILE_10PERC="/tmp/countdown_perc"
FILE_REST="/tmp/pomo_rest"

CLASS="normal"
if [ -f "$FILE_TIME" ]; then
  TIME=$(cat "$FILE_TIME")
  CLASS="critical"
else
  TIME="00:00"
fi

if [ -f "$FILE_10PERC" ]; then
  ICON="󰚭"
elif [ -f "$FILE_HALF" ]; then
  ICON="󱦟"
else
  ICON="󰞌"
fi

echo "{\"text\": \"$TIME $ICON\", \"class\": \"$CLASS\"}"
