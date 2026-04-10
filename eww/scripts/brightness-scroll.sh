#!/bin/bash
case "$1" in
    up)   brightnessctl set +1% ;;
    down) brightnessctl set 1%- ;;
esac
