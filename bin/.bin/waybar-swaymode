#!/usr/bin/env bash
while true; do
  mode=$(swaymsg -t subscribe '[ "mode" ]' | jq -r '.change')
  pkill -RTMIN+7 waybar
done
