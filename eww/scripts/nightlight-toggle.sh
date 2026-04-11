#!/bin/bash
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    if [ "$1" = "reset" ]; then
        pkill wlsunset
    else
        wlsunset -T 5000 -g 0.7 &
    fi
else
    if [ "$1" = "reset" ]; then
        redshift -x
    else
        redshift -O 4000 &
    fi
fi
