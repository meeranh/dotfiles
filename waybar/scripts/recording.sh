#!/bin/bash
case "$1" in
    sep) [ -f /tmp/recording ] && echo "" ;;
    icon) [ -f /tmp/recording ] && echo "󰑊" ;;
esac
