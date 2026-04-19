#!/usr/bin/env bash

FILE_TIME="/tmp/pomo_time"
FILE_HALF="/tmp/pomo_half"
FILE_REST="/tmp/pomo_rest"

if [ -f "$FILE_TIME" ]; then
  TIME=$(cat "$FILE_TIME")
else
  TIME="25"
fi

TIME_INT=$((10#$TIME))

if [ -e "$FILE_REST" ]; then
  CLASS="critical"
else
  CLASS="normal"
fi

if [ "$TIME_INT" -eq 1 ]; then
  ICON=""
elif [ -f "$FILE_HALF" ]; then
  HALF_VAL=$(cat "$FILE_HALF")
  HALF_INT=$((10#$HALF_VAL))

  if [ "$TIME_INT" -le "$HALF_INT" ]; then
    ICON=""
  else
    ICON=""
  fi
else
  ICON=""
fi

echo "{\"text\": \"$TIME $ICON\", \"class\": \"$CLASS\"}"
