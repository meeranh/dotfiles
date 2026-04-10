#!/bin/bash
bat0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
bat1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
state0=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
state1=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)

if [ -n "$bat1" ]; then
    avg=$(( (bat0 + bat1) / 2 ))
    display="$bat0 \u00b7 $bat1%"
else
    avg=$bat0
    display="$bat0%"
fi

if [ "$avg" -ge 80 ]; then icon=" "
elif [ "$avg" -ge 60 ]; then icon=" "
elif [ "$avg" -ge 40 ]; then icon=" "
elif [ "$avg" -ge 20 ]; then icon=" "
else icon=" "
fi

charging="false"
if [ "$state0" = "Discharging" ] || [ "$state1" = "Discharging" ]; then
    charging="false"
else
    charging="true"
fi

case "$1" in
    text) echo "$display" ;;
    icon) echo "$icon" ;;
    charging) echo "$charging" ;;
esac
