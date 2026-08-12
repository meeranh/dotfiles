#!/bin/sh
# Enable the Caps -> Escape remap WITHOUT leaving Caps Lock toggled on.
#
# Bound to $mod+Caps_Lock with --release (see i3/config). Firing on release
# matters: the Caps key is a real locking key until we remap it, so the trigger
# press flips caps-lock ON. On release that toggle has fully settled, so we can
# reliably read it, clear it, and only then remap the key to Escape.

# Clear caps-lock if the trigger press turned it on. python-xlib reads the real
# lock state and clears it only when set; xdotool is the fallback (a blind
# toggle, which is correct here because on release caps-lock has settled ON).
python3 - <<'PY' 2>/dev/null || xdotool key Caps_Lock
from Xlib import display, X
from Xlib.ext import xtest
from Xlib.XK import XK_Caps_Lock
d = display.Display()
if d.screen().root.query_pointer().mask & X.LockMask:
    kc = d.keysym_to_keycode(XK_Caps_Lock)
    xtest.fake_input(d, X.KeyPress, kc)
    xtest.fake_input(d, X.KeyRelease, kc)
    d.sync()
PY

# Now make the physical Caps key send Escape.
setxkbmap -option caps:escape
