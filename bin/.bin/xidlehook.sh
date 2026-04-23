#!/usr/bin/env bash

xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  --not-when-audio \
  --timer 150 \
  'slock' \
  '' \
  --timer 75 \
  'xset -display :0.0 dpms force off' \
  'xset -display :0.0 dpms force on'
