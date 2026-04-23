num=$(ls -l /dev/input/by-id | grep 'Microntek' | awk "NR==1{print;exit}" | sed 's/.*\(..\)$/\1/' | sed 's/[^0-9]*//g')
echo $num 
sudo xboxdrv --evdev /dev/input/event$num \
--evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_RZ=x2,ABS_Z=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
--axismap -Y1=Y1,Y2=X2,-X2=Y2 \
--evdev-keymap BTN_TOP=x,BTN_TRIGGER=y,BTN_THUMB2=a,BTN_THUMB=b,BTN_BASE3=back,BTN_BASE4=start,BTN_BASE=lb,BTN_BASE2=rb,BTN_TOP2=lt,BTN_PINKIE=rt,BTN_BASE5=tl,BTN_BASE6=tr \
--mimic-xpad --silent
