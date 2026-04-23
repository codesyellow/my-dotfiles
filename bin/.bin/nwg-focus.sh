#!/usr/bin/env bash

if pgrep "nwg-wrapper" > /dev/null; then
  echo "nwg-wrapper is running, so it will toggle"
  pkill -f -10 nwg-wrapper
else
  echo "nwg-wrapper is not running, so it will be executed"
  nohup nwg-wrapper -o "HDMI-A-2" -s sysinfo.sh -c sysinfo.css -r 1000 -p right -mr 50 -a start -mt 50 -j right > /dev/null 2>&1 &
fi


