"""Logs the focused Niri workspace to ActivityWatch as heartbeat events.

Usage: aw-watcher-niri-workspace.py <path-to-niri-binary>
"""

import json
import select
import socket
import subprocess
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone
from typing import Any

Workspace = dict[str, Any]

POLL_SECONDS = 1.0
PULSETIME = POLL_SECONDS * 3
API = "http://localhost:5600/api/0"
BUCKET = f"aw-watcher-niri-workspace_{socket.gethostname()}"


def request(method: str, path: str, payload: dict[str, Any]) -> None:
    req = urllib.request.Request(
        f"{API}{path}",
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
        method=method,
    )
    urllib.request.urlopen(req)


def ensure_bucket() -> None:
    try:
        request(
            "POST",
            f"/buckets/{BUCKET}",
            {
                "client": "aw-watcher-niri-workspace",
                "type": "niri.workspace",
                "hostname": socket.gethostname(),
            },
        )
    except urllib.error.HTTPError as e:
        # 304: the bucket already exists.
        if e.code != 304:
            raise


def heartbeat(data: dict[str, str], timestamp: datetime) -> None:
    request(
        "POST",
        f"/buckets/{BUCKET}/heartbeat?pulsetime={PULSETIME}",
        {"timestamp": timestamp.isoformat(), "duration": 0, "data": data},
    )


def focused_workspace(workspaces: dict[int, Workspace]) -> dict[str, str] | None:
    for ws in workspaces.values():
        if ws["is_focused"]:
            # "title" is what aw-webui falls back to as the event label for
            # bucket types it doesn't know.
            return {
                "title": ws["name"] or str(ws["idx"]),
                "output": ws["output"] or "",
            }
    return None


def main() -> None:
    niri = sys.argv[1]
    ensure_bucket()

    proc = subprocess.Popen(
        [niri, "msg", "-j", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )
    assert proc.stdout is not None
    workspaces: dict[int, Workspace] = {}
    last_sent = -PULSETIME

    while True:
        ready, _, _ = select.select([proc.stdout], [], [], POLL_SECONDS)
        switched = False
        if ready:
            line = proc.stdout.readline()
            if not line:
                sys.exit("niri event stream closed")
            event = json.loads(line)
            if "WorkspacesChanged" in event:
                workspaces = {
                    ws["id"]: ws for ws in event["WorkspacesChanged"]["workspaces"]
                }
                switched = True
            elif "WorkspaceActivated" in event:
                activated = event["WorkspaceActivated"]
                if activated["focused"] and activated["id"] in workspaces:
                    for ws in workspaces.values():
                        ws["is_focused"] = ws["id"] == activated["id"]
                    switched = True

        # The stream emits chatter (window title changes, ...) faster than
        # once per POLL_SECONDS, so heartbeats are sent on wall-clock time
        # rather than per line.
        data = focused_workspace(workspaces)
        if data is None:
            continue
        if not switched and time.monotonic() - last_sent < POLL_SECONDS:
            continue
        try:
            heartbeat(data, datetime.now(timezone.utc))
            last_sent = time.monotonic()
        except urllib.error.URLError as e:
            print(f"heartbeat failed: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()
