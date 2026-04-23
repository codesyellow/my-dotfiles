#!/usr/bin/env bash
CLIENTS=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).app_id')
CLASS_NAME=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | (.class // .window_properties.class // empty)')
NAME=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).name')

CURRENT_WORKSPACE=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num')

write_rule() {
    echo "for_window [$2=\"^$1$\"] move to workspace $CURRENT_WORKSPACE" >>~/.config/sway/rules.conf
}

if ! [[ "$CLIENTS" == "null" ]]; then
    write_rule "$CLIENTS" "app_id"
elif [[ -n "$CLASS_NAME" ]]; then
    echo "$CLIENTS"
    write_rule "$CLASS_NAME" "class"
fi
