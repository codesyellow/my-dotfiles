#/usr/bin/env bash
swayidle -w \
    timeout 300 'swaylock --image VGA-1:/home/digo/.wallpapers/ign_unsplash21.png --image HDMI-A-1:/home/digo/.wallpapers/ign_unsplash21.png' \
    timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"'
