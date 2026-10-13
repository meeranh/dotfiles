#!/bin/bash
# Auto-detects monitors and lays them out: laptop panel as primary at its
# fastest refresh rate, any connected external display beside it, unplugged
# outputs off. Works on any laptop without needing output names hardcoded.

# Where external displays sit relative to the laptop panel
SIDE="--right-of"

XRANDR=$(xrandr --query 2>/dev/null)
INTERNAL=$(echo "$XRANDR" | awk '/^(eDP|LVDS)[^ ]* connected/ {print $1; exit}')

[ -z "$INTERNAL" ] && exit 0

# Preferred resolution of the panel and the fastest rate it offers at it
read -r MODE RATE < <(echo "$XRANDR" | awk -v out="$INTERNAL" '
    $1 == out { found = 1; next }
    found && /^[^ ]/ { exit }
    found && /\+/ {
        for (i = 2; i <= NF; i++) { r = $i; gsub(/[*+]/, "", r); if (r + 0 > max) max = r + 0 }
        print $1, max; exit
    }')

args=(--output "$INTERNAL" --primary)
if [ -n "$RATE" ]; then
    args+=(--mode "$MODE" --rate "$RATE")
else
    args+=(--auto)
fi

prev=$INTERNAL
while read -r name state _; do
    [ "$name" = "$INTERNAL" ] && continue
    if [ "$state" = "connected" ]; then
        args+=(--output "$name" --auto "$SIDE" "$prev")
        prev=$name
    else
        args+=(--output "$name" --off)
    fi
done < <(echo "$XRANDR" | grep -E '^[^ ]+ (dis)?connected')

xrandr "${args[@]}"

# Re-apply the wallpaper so it covers the new layout
[ -x ~/.fehbg ] && ~/.fehbg
