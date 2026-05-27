#!/bin/bash
# Auto-detects touchpad device name and applies libinput settings.
# Works on any laptop without needing the device name hardcoded.

TOUCHPAD=$(xinput list --name-only 2>/dev/null | grep -iE 'touchpad' | head -1)

[ -z "$TOUCHPAD" ] && exit 0

xinput set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Tapping Drag Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Tapping Drag Lock Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Disable While Typing Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Middle Emulation Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Natural Scrolling Enabled" 0
