#!/bin/bash
while true; do
    volume=$(pamixer --get-volume)
    root=$(df -h | awk '{ if ($6 == "/") print $4 }')
    root_int=${root::-1}
    home=$(df -h | awk '{ if ($6 == "/home") print $4 }')
    freemen_per=$(free -m | awk 'NR==2{print $3*100/$2 }')
    freemen_per_int=$(printf "%.0f\n" "$freemen_per")
    date=$(date +"%m/%d %H:%M")
    cpu=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' \
        <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))
            cpu_per_int=$(printf "%.0f\n" "$cpu")

            status=""

            if [[ $volume -ge 45 ]]; then
                status+="   |$volume% "
            elif [[ $volume -le 10 ]]; then
                status+="   |$volume% "
            elif [[ $volume -ge 35 ]]; then
                status+="   |$volume% "
            else
                status+="   |$volume% "
            fi

            if [[ $cpu_per_int -ge 80 ]]; then
                status+="|$cpu_per_int% "
            else
                status+="|$cpu_per_int% "
            fi

            if [[ $freemen_per_int -ge 70 ]]; then
                status+="|$freemen_per_int% "
            elif [[ $fremen_per_int -ge 60 ]]; then
                status+="|$freemen_per_int% "
            else
                status+="|$freemen_per_int% "
            fi

            if [[ $(echo "$root_int < 5" | bc) -ne 0 ]]; then
                echo E
                status+="^bg(444444)$root_int""g^bg()" 
            elif [[ $(echo "$root_int < 2" | bc) -ne 0 ]]; then 
                status+="$root_int""g " 
            else
                status+="|$root_int""g " 
            fi

            status+="^bg(444444)|$date^bg()"

            dwlb -status all "$status"
            echo '$home'
            sleep 1s    # Update time every minute
        done
