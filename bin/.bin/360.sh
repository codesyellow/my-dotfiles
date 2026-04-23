#!/bin/bash
sleep 3

value=0

usage() {
    echo "Usage: $0 <increment>"
    echo "Example: $0 10"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

for ((i = 0; i < 10; i++)); do
    value=$((value + $1))
    ydotool mousemove $value 0
    echo "Current value: $value"
    sleep 1
done
