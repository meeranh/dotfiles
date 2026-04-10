#!/bin/bash
case "$1" in
    up)   pactl set-sink-volume @DEFAULT_SINK@ +1% ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -1% ;;
esac
