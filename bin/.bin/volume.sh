#!/bin/bash
function check_dependencies() {
  local ret=0
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Missing dependency: $cmd."
      ret=1
    fi
  done
  return $ret
}

(check_dependencies "pamixer") || exit 1

user_input="$1"

case "$user_input" in
up)
  pamixer -i 5
  ;;
down)
  pamixer -d 5
  ;;
mute)
  if [[ $(pamixer --get-mute) == 'true' ]]; then
    pamixer -u
  else
    pamixer -m
  fi
  ;;
small_up)
  pamixer -i 1
  ;;
small_down)
  pamixer -d 1
  ;;
*)
  pamixer --get-volume
  ;;
esac

if [[ $(pamixer --get-mute) == 'true' ]]; then
  current_volume=0
else
  current_volume=$(pamixer --get-volume)
fi
#fyi -r 32 "$current_volume"

echo "$current_volume" >>$XDG_RUNTIME_DIR/wob.sock
