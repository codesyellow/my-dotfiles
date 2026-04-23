#!/usr/bin/env bash
display_switched="0"

while true; do
  # Check the current TTY
  current_tty=$(cat /sys/class/tty/tty0/active)

  if [[ "$current_tty" == "tty1" ]] && [[ "$display_switched" == "1" ]]; then
    killall dunst 
    DISPLAY=:0 nohup dunst &
    display_switched="0"
    echo "Dunst was started on TTY1 (display 0)"
  elif [[ "$current_tty" == "tty2" ]] && [[ "$display_switched" == "0" ]]; then
    killall dunst 
    DISPLAY=:1 nohup dunst &
    display_switched="1"
    echo "Dunst was started on TTY2 (display 1)"
  fi
  sleep 2
done
