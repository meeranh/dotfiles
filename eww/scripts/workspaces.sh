#!/bin/bash
# Use swaymsg or i3-msg depending on which WM is running
if command -v swaymsg &>/dev/null && pgrep -x sway &>/dev/null; then
    WM_MSG="swaymsg"
elif command -v i3-msg &>/dev/null; then
    WM_MSG="i3-msg"
else
    echo "[]"
    exit 1
fi

get_workspaces() {
    ws=$($WM_MSG -t get_workspaces 2>/dev/null)
    echo "$ws" | jq -c '
        . as $all |
        [range(1;11) | tostring | . as $i |
            ($all | map(select(.name == $i)) | first) as $ws |
            if $ws == null then
                {"name": $i, "state": "empty", "icon": "󰑊 "}
            elif $ws.focused then
                {"name": $i, "state": "focused", "icon": "󰮯 "}
            elif $ws.urgent then
                {"name": $i, "state": "urgent", "icon": "󰊠 "}
            else
                {"name": $i, "state": "occupied", "icon": "󰊠 "}
            end
        ]'
}

get_workspaces

if [ "$WM_MSG" = "swaymsg" ]; then
    MONITOR_FLAG="--monitor"
else
    MONITOR_FLAG="-m"
fi

$WM_MSG -t subscribe '["workspace"]' $MONITOR_FLAG 2>/dev/null | while read -r _; do
    get_workspaces
done
