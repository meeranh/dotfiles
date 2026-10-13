#!/usr/bin/env python3 -u
import json
import sys
import os
from i3ipc import Connection, Event

FOCUSED = "󰮯 "
EMPTY = "󰑊 "
GHOST = "󰊠 "

i3 = Connection()

def get_workspaces(*args):
    active = i3.get_workspaces()
    lookup = {w.name: w for w in active}
    # 1-10 go on the laptop bar, 11-20 on the external monitor's bar
    external = sum(o.active for o in i3.get_outputs()) > 1
    result = []
    for n in range(1, 21):
        name = str(n)
        ws = lookup.get(name)
        screen = "external" if n > 10 and external else "laptop"
        gap = ""
        if n > 10 and not external:
            # No external monitor: only show 11-20 that are in use, after a gap
            if ws is None:
                continue
            if int(result[-1]["name"]) <= 10:
                gap = "ws-external"
        if ws is None:
            state, icon = "empty", EMPTY
        elif ws.focused:
            state, icon = "focused", FOCUSED
        elif ws.visible:
            state, icon = "visible", FOCUSED
        elif ws.urgent:
            state, icon = "urgent", GHOST
        else:
            state, icon = "occupied", GHOST
        result.append({"name": name, "state": state, "icon": icon,
                       "screen": screen, "gap": gap})
    data = json.dumps(result)
    sys.stdout.write(data + "\n")
    sys.stdout.flush()
    os.system("eww update workspaces-raw='" + data + "'")

get_workspaces()
i3.on(Event.WORKSPACE, get_workspaces)
i3.on(Event.OUTPUT, get_workspaces)
i3.main()
