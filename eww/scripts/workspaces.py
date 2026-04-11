#!/usr/bin/env python3
import json
import sys
from i3ipc import Connection, Event

FOCUSED = "󰮯 "
EMPTY = "󰑊 "
GHOST = "󰊠 "

i3 = Connection()

def get_workspaces(*args):
    active = i3.get_workspaces()
    lookup = {w.name: w for w in active}
    result = []
    for i in range(1, 11):
        name = str(i)
        ws = lookup.get(name)
        if ws is None:
            result.append({"name": name, "state": "empty", "icon": EMPTY})
        elif ws.focused:
            result.append({"name": name, "state": "focused", "icon": FOCUSED})
        elif ws.urgent:
            result.append({"name": name, "state": "urgent", "icon": GHOST})
        else:
            result.append({"name": name, "state": "occupied", "icon": GHOST})
    print(json.dumps(result), flush=True)

get_workspaces()
i3.on(Event.WORKSPACE, get_workspaces)
i3.main()
