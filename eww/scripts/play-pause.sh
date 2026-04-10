#!/bin/bash
status=$(playerctl status 2>/dev/null || echo "Stopped")
case $status in
    Playing) echo '' ;;
    *) echo '' ;;
esac

playerctl status --follow 2>/dev/null | while read -r status; do
    case $status in
        Playing) echo '' ;;
        *) echo '' ;;
    esac
done
