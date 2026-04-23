#!/bin/bash
ids=$(xinput --list | awk -v search="Sony Interactive Entertainment Wireless Controller Touchpad" \
'$0 ~ search {match($0, /id=[0-9]+/);\
if (RSTART) \
print substr($0, RSTART+3, RLENGTH-3)\
}'\
)
for i in $ids do
xinput --disable $i
done
