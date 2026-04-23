#!/usr/bin/env bash

COLOR_TITLE="#88c0d0" 
COLOR_TEXT="#eceff4"  
TEMP_FILE="/tmp/nwg_stats"
HDD_PATH="$HOME/.HDD"

while true; do
    TIME=$(date "+%a, %d %b - %H:%M")
    
    # CPU e RAM (mantidos como antes)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')"%"
    read MEM_USED MEM_TOTAL < <(free -h | awk '/Mem:/ { print $3, $2 }')

    # Disco: Pegando apenas o espaço DISPONÍVEL ($4)
    ROOT_FREE=$(df -h / | awk 'NR==2 {print $4}')
    HOME_FREE=$(df -h /home | awk 'NR==2 {print $4}')

    if [ -d "$HDD_PATH" ]; then
      HDD_FREE=$(df -h "$HDD_PATH" | awk 'NR==2 {print $4}')
    else
      HDD_FREE="n/a"
    fi

    OUTPUT=$(cat <<EOF
<span font_family='Victor Mono' font_weight='bold' font_style='italic' size='large'>
<span foreground='$COLOR_TITLE'> time:</span> <span foreground='$COLOR_TEXT'>$TIME</span>

<span foreground='$COLOR_TITLE'> cpu:</span>  <span foreground='$COLOR_TEXT'>$CPU_USAGE</span>
<span foreground='$COLOR_TITLE'> ram:</span>  <span foreground='$COLOR_TEXT'>$MEM_USED / $MEM_TOTAL</span>

<span foreground='$COLOR_TITLE'> disk free</span>
<span foreground='$COLOR_TEXT'>  root (/)  : $ROOT_FREE</span>
<span foreground='$COLOR_TEXT'>  home (~)  : $HOME_FREE</span>
<span foreground='$COLOR_TEXT'>  hdd (~/)  : $HDD_FREE</span>
</span>
EOF
)

    echo "$OUTPUT" | tr '[:upper:]' '[:lower:]' > "$TEMP_FILE"
    sleep 5 # Aumentei para 5s para ser ainda mais leve, já que disco não muda tão rápido
done
