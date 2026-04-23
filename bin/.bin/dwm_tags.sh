#!/bin/bash

MONITOR="$1"

# Map monitor name to monitor index (adjust based on your setup)
case "$MONITOR" in
HDMI1) MON_INDEX=0 ;;
VGA1) MON_INDEX=1 ;;
*) MON_INDEX=0 ;; # default fallback
esac

# Get tag string from the correct atom
TAG_ATOM="_DWM_TAGS_MON$MON_INDEX"

# Extract tag string
TAG_STRING=$(xprop -root "$TAG_ATOM" 2>/dev/null | cut -d '"' -f2)

# Output to Polybar
echo "$TAG_STRING"
