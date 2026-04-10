#!/bin/bash
STATUS_FILE="/tmp/statusbar"

output() {
    if [[ -f "$STATUS_FILE" ]]; then
        cat "$STATUS_FILE"
    else
        playerctl metadata --format '{{trunc(title,30)}}' 2>/dev/null || echo "Not Playing"
    fi
}

output

inotifywait -m -e create,delete,modify,move --format '%f' /tmp 2>/dev/null | while read -r filename; do
    [[ "$filename" == "statusbar" ]] && output
done &

playerctl metadata --follow --format '{{trunc(title,30)}}' 2>/dev/null | while read -r title; do
    [[ ! -f "$STATUS_FILE" ]] && echo "${title:-Not Playing}"
done
