#!/usr/bin/env bash
# Output initial state
status=$(playerctl status 2>/dev/null || echo "Stopped")
case $status in
    Playing) echo '' ;;
    Paused) echo '' ;;
    *) echo '' ;;
esac

# Follow for updates
playerctl status --follow 2>/dev/null | while read -r status; do
    case $status in
        Playing) echo '' ;;
        Paused) echo '' ;;
        *) echo '' ;;
    esac
done
