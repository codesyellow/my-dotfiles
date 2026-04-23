#!/usr/bin/env bash

times=0
seconds=0
wait=0
stretch_path="/tmp/stretch"
stretch_start="/tmp/stretch_start"

display_help() {
    echo "options:
  -h, --help  show this help message and exit
  -t       How many times you want the to stretch
  -s       How many seconds you want for each stretch
  -w       How many seconds you want to stop between each stretch"
}

# Parse command-line options
while getopts ":t:s:w:h" opt; do
    case ${opt} in
    t)
        times=$OPTARG
        ;;
    s)
        seconds=$OPTARG
        ;;
    w)
        wait=$OPTARG
        ;;
    h)
        display_help
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        display_help
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        display_help
        exit 1
        ;;
    esac
done

if [[ "$@" == "" ]]; then
    display_help
    exit 1
fi

if [[ -f "$stretch_path" ]]; then
    echo "Its already running!"
    notify-send.sh "Already running!"
    exit 1
fi

realtime=$times

while [[ "$times" -ge 0 ]]; do
    if [[ "$times" == "$realtime" ]]; then
        paplay ~/.audios/stretch_start.wav
        touch "$stretch_start"
        echo "get ready!"
        sleep 3
    fi

    if [[ -f "$stretch_start" ]]; then
        rm "$stretch_start"
    fi

    if [[ ! -f "$stretch_path" ]]; then
        touch "$stretch_path"
    fi

    if [[ "$times" == 0 ]]; then
        canberra-gtk-play -f ~/.audios/stretch_ended.wav
        rm "$stretch_path"
        notify-send.sh -u critical "Stretch ended!"
        break
    else
       canberra-gtk-play -f ~/.audios/stretch_work.mp3
        sleep $seconds
        if [[ -n "$wait" ]] && [[ ! "$times" == 1 ]]; then
            touch "/tmp/stop"
            echo "Stop!!"
            canberra-gtk-play -f ~/.audios/stretch_breaks.mp3
            sleep $wait
            rm "/tmp/stop"
        fi
    fi

    ((times--))
done
