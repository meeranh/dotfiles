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
    result = []
    for n in range(1, 11):
        name = str(n)
        ws = lookup.get(name)
        if ws is None:
            result.append({"name": name, "state": "empty", "icon": EMPTY})
        elif ws.focused:
            result.append({"name": name, "state": "focused", "icon": FOCUSED})
        elif ws.urgent:
            result.append({"name": name, "state": "urgent", "icon": GHOST})
        else:
            result.append({"name": name, "state": "occupied", "icon": GHOST})
    data = json.dumps(result)
    sys.stdout.write(data + "\n")
    sys.stdout.flush()
    os.system("eww update workspaces-raw='" + data + "'")

get_workspaces()
i3.on(Event.WORKSPACE, get_workspaces)
i3.main()
