#!/bin/bash
case "$1" in
    sep) pgrep -x wf-recorder > /dev/null && echo "" ;;
    icon) pgrep -x wf-recorder > /dev/null && echo "󰑊" ;;
esac
