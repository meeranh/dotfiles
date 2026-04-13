#!/bin/bash
# Event-driven brightness listener using inotifywait
# Pushes updates to eww instantly via eww update

BRIGHTNESS_FILE=$(find /sys/class/backlight -name "actual_brightness" 2>/dev/null | head -1)

get_brightness() {
    val=$(brightnessctl -m 2>/dev/null | awk -F, '{print $4}' | tr -d '%')
    eww update backlight="$val" 2>/dev/null
    echo "$val"
}

# Push initial value
get_brightness

if [ -n "$BRIGHTNESS_FILE" ]; then
    inotifywait -m -e modify "$BRIGHTNESS_FILE" --format '%w' 2>/dev/null | while read -r _; do
        get_brightness
    done
else
    # Fallback poll if no sysfs file found
    while sleep 2; do
        get_brightness
    done
fi
