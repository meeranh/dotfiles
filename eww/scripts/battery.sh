#!/bin/bash
bat0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
bat1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
state0=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
state1=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)

# Single percentage: average of present batteries, ignoring dormant/empty (0%)
# slots (e.g. a phantom BAT0 that the HyperV host exposes alongside the real one).
sum=0; n=0
for c in "$bat0" "$bat1"; do
    if [ -n "$c" ] && [ "$c" -gt 0 ] 2>/dev/null; then sum=$((sum + c)); n=$((n + 1)); fi
done
if [ "$n" -gt 0 ]; then avg=$((sum / n)); else avg=${bat0:-0}; fi
display="$avg%"

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
