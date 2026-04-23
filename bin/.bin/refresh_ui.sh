#!/bin/bash

niri msg action power-on-monitors

pkill -x gammastep
sleep 0.5 
gammastep -P -O 2500 &

pkill -x nwg-wrapper
sleep 0.5
nohup nwg-wrapper -o "HDMI-A-2" -s sysinfo.sh -c sysinfo.css -r 1000 -p right -mr 50 -a start -mt 50 -j right > /dev/null 2>&1 &
