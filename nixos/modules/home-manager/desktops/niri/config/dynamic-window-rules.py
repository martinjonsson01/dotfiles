"""
Applies window rules dynamically.

Some windows don't have the right title and app-id when they open, and only set
them afterward.

Usage: fill in the RULES array below, then run the script.
"""

from dataclasses import dataclass, field
from typing import Optional
import json
import os
import re
from socket import AF_UNIX, SHUT_WR, socket


@dataclass(kw_only=True)
class Match:
    title: str | None = None
    app_id: str | None = None

    def matches(self, window):
        if self.title is None and self.app_id is None:
            return False

        matched = True

        if self.title is not None:
            matched &= re.search(self.title, window["title"]) is not None
        if self.app_id is not None:
            matched &= re.search(self.app_id, window["app_id"]) is not None

        return matched


@dataclass
class Rule:
    match: list[Match] = field(default_factory=list)
    exclude: list[Match] = field(default_factory=list)
    open_on_workspace: Optional[str] = None

    def matches(self, w):
        if len(self.match) > 0 and not any(m.matches(w) for m in self.match):
            return False
        if any(m.matches(w) for m in self.exclude):
            return False

        return True


# Write your rules here. One Rule() = one window-rule {}.
RULES = [
    # window-rule {} with one match.
    # Rule([Match(title="Bitwarden", app_id="firefox")]),
    # window-rule {} with one match and one exclude.
    # Rule(
    #     [Match(title="rs")],
    #     exclude=[Match(app_id="Alacritty")],
    # ),
    # window-rule {} with two matches.
    # Rule(
    #     [
    #         Match(app_id="^foot$"),
    #         Match(app_id="^mpv$"),
    #     ]
    # ),
    Rule(
        [Match(app_id="^Code$", title="nixos - Visual Studio Code$")],
        open_on_workspace="nixos",
    ),
]


if len(RULES) == 0:
    print("fill in the RULES list, then run the script")
    exit()


niri_socket = socket(AF_UNIX)
niri_socket.connect(os.environ["NIRI_SOCKET"])
file = niri_socket.makefile("rw")

_ = file.write('"EventStream"')
file.flush()
niri_socket.shutdown(SHUT_WR)

windows = {}


def send(request):
    with socket(AF_UNIX) as niri_socket:
        niri_socket.connect(os.environ["NIRI_SOCKET"])
        file = niri_socket.makefile("rw")
        _ = file.write(json.dumps(request))
        file.flush()


def float(id: int):
    send({"Action": {"MoveWindowToFloating": {"id": id}}})


def move_to_workspace(window_id: int, workspace_name: str):
    send(
        {
            "Action": {
                "MoveWindowToWorkspace": {
                    "window_id": window_id,
                    "reference": {"Name": workspace_name},
                    "focus": False,
                }
            }
        }
    )


def update_matched(win):
    win["matched"] = False
    if existing := windows.get(win["id"]):
        win["matched"] = existing["matched"]

    matched_before = win["matched"]
    matched_rule = None
    for rule in RULES:
        matched = any(r.matches(win) for r in RULES)
        win["matched"] = matched
        if matched:
            matched_rule = rule

    if win["matched"] and not matched_before:
        print(f"rule matched for title={win['title']}, app_id={win['app_id']}")
        if matched_rule.open_on_workspace is not None:
            print(f"moving window to {matched_rule.open_on_workspace}")
            move_to_workspace(win["id"], matched_rule.open_on_workspace)


for line in file:
    event = json.loads(line)

    if changed := event.get("WindowsChanged"):
        for win in changed["windows"]:
            update_matched(win)
        windows = {win["id"]: win for win in changed["windows"]}
    elif changed := event.get("WindowOpenedOrChanged"):
        win = changed["window"]
        update_matched(win)
        windows[win["id"]] = win
    elif changed := event.get("WindowClosed"):
        del windows[changed["id"]]
