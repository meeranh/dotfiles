#!/bin/bash
# Event-driven volume listener
# stdbuf forces line-buffered output from pactl subscribe

get_volume() {
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk -F/ '{print $2}' | tr -dc 0-9)
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | sed 's/Mute: //')
    eww update volume="$vol" volume-muted="$mute" 2>/dev/null
    echo "$vol"
}

# Retry until we get a valid volume (PipeWire may not be ready at boot)
for i in $(seq 1 20); do
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk -F/ '{print $2}' | tr -dc 0-9)
    if [ -n "$vol" ] && [ "$vol" != "0" ]; then
        break
    fi
    sleep 0.5
done

get_volume

stdbuf -oL pactl subscribe 2>/dev/null | while read -r line; do
    case "$line" in
        *"sink"*) get_volume ;;
    esac
done
