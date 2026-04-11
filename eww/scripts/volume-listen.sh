#!/bin/bash
# Event-driven volume listener
# stdbuf forces line-buffered output from pactl subscribe

get_volume() {
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F/ '{print $2}' | tr -dc 0-9)
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | sed 's/Mute: //')
    eww update volume="$vol" volume-muted="$mute" 2>/dev/null
}

get_volume

stdbuf -oL pactl subscribe 2>/dev/null | while read -r line; do
    case "$line" in
        *"sink"*) get_volume ;;
    esac
done
