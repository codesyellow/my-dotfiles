#!/usr/bin/env bash

INTERVAL=2

disk_free() {
    df -h --output=avail "$1" 2>/dev/null | tail -n 1 | tr -d ' '
}

while true; do
    HDD_FREE=$(disk_free "$HOME/.HDD")
    SSD_FREE=$(disk_free "/home")
    ROOT_FREE=$(disk_free "/")

    DATE=$(date "+%d %b, %a %H:%M")

    if command -v pamixer >/dev/null 2>&1; then
        VOLUME=$(pamixer --get-volume)
        VOL_STATUS="VOL ${VOLUME}%"
    else
        VOL_STATUS="VOL N/A"
    fi

    STATUS="ROOT: ${ROOT_FREE} | SSD: ${SSD_FREE} | HDD: ${HDD_FREE} | ${VOL_STATUS} | ${DATE}"

    xsetroot -name "$STATUS"

    sleep "$INTERVAL"
done
