#!/usr/bin/env bash
while true; do
    bat0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
    bat1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
    state0=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    state1=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)

    if [ -n "$bat1" ]; then
        avg=$(( (bat0 + bat1) / 2 ))
        display="$bat0 · $bat1%"
    else
        avg=$bat0
        display="$bat0%"
    fi

    if [ "$avg" -ge 80 ]; then icon="  "
    elif [ "$avg" -ge 60 ]; then icon="  "
    elif [ "$avg" -ge 40 ]; then icon="  "
    elif [ "$avg" -ge 20 ]; then icon="  "
    else icon="  "
    fi

    if [ "$state0" = "Charging" ] || [ "$state0" = "Full" ] || \
       [ "$state1" = "Charging" ] || [ "$state1" = "Full" ]; then
        class="charging"
    else
        class="discharging"
    fi

    echo "{\"text\": \"$icon<span color='#c0caf5'>$display</span>\", \"class\": \"$class\"}"
    sleep 5
done
