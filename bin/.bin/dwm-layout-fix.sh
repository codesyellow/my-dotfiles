#!/usr/bin/env bash
while true; do
  xkbcommand=$(setxkbmap -query)
  if ! echo "$xkbcommand" | grep -q "caps:super"; then
    setxkbmap -layout us,us -variant ,intl -option "caps:super,grp:alt_shift_toggle"
    break
  fi
  sleep 10
done
