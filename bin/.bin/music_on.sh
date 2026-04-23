#!/usr/bin/env bash

PRESET_MUSIC="HeavyBass"
PRESET_LOUDNESS="Loudness"
LOG_PATH="/tmp/music_on"
EQ_PATH="/tmp/equalizer_volume"
if [[ -f "$EQ_PATH" ]]; then
  loudness_volume=$(cat "$EQ_PATH")
fi
if pactl list sink-inputs | grep -A 20 "YouTube Music" | grep -q 'pulse.corked = "false"'; then
  if [[ ! -f "$LOG_PATH" ]]; then
    echo "YouTube Music detectado tocando. Mudando para preset de Música..."
    easyeffects --load-preset "$PRESET_MUSIC" && touch "$LOG_PATH" && echo $(pamixer --get-volume) >"$EQ_PATH"
  fi
else
  echo oi
  if [[ -f "$LOG_PATH" ]]; then
    echo "YouTube Music pausado ou fechado. Voltando para $PRESET_LOUDNESS..."
    easyeffects --load-preset "$PRESET_LOUDNESS"

    if [[ -f "$EQ_PATH" ]]; then
      pamixer --set-volume "$loudness_volume" && echo "volume was set to the default"
      rm "$EQ_PATH"
    fi
    rm "$LOG_PATH" && echo "music_on file was removed"
  fi
fi
