#!/bin/bash
# One eww bar per screen: "bar" on the laptop panel and "bar-external" on the
# external monitor when one is active.
#   bars.sh          (re)start the bars
#   bars.sh toggle   hide the bars, or show them again

RUNNING=$(pgrep -x eww)

# Stop the daemon, including strays that lost their socket
eww kill >/dev/null 2>&1
sleep 0.3
pkill -x eww
for _ in $(seq 1 30); do
    pgrep -x eww >/dev/null || break
    sleep 0.1
done

[ "$1" = "toggle" ] && [ -n "$RUNNING" ] && exit 0

# Always let "eww open" start the daemon itself, in a single call. Opening on
# an already running daemon takes longer than eww's reply timeout, and eww then
# spawns a second daemon that draws a duplicate set of bars.
if [ "$(xrandr --listactivemonitors 2>/dev/null | awk 'NR == 1 {print $2}')" -gt 1 ] 2>/dev/null; then
    eww open-many bar bar-external
else
    eww open bar
fi
