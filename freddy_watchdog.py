# -*- coding: utf-8 -*-
"""
FREDDY Watchdog — startet freddy_server.py neu wenn er abstuerzt.
Wird von FREDDY_STARTEN.vbs aufgerufen (unsichtbar im Hintergrund).
"""
import subprocess, sys, time, os
from pathlib import Path

HERE   = Path(__file__).parent.resolve()
SERVER = HERE / "freddy_server.py"
LOG    = HERE / "freddy_watchdog.log"
PYTHON = sys.executable

def log(msg):
    try:
        with open(LOG, "a", encoding="utf-8") as f:
            from datetime import datetime
            f.write(datetime.now().isoformat()[:19] + " " + msg + "\n")
    except Exception:
        pass

log("Watchdog gestartet")

restart_count = 0
while True:
    log(f"Starte Server (Versuch {restart_count + 1})")
    try:
        proc = subprocess.Popen(
            [PYTHON, "-X", "utf8", str(SERVER)],
            cwd=str(HERE),
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
        proc.wait()
        code = proc.returncode
        log(f"Server beendet (exit={code})")
    except Exception as e:
        log(f"Fehler beim Starten: {e}")

    restart_count += 1
    if restart_count > 20:
        log("Zu viele Neustarts — Watchdog beendet sich")
        break

    time.sleep(3)
