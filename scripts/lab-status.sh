#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="$ROOT/.lab-state/auto-audit.pid"
PID="$(cat "$PID_FILE" 2>/dev/null || true)"

echo "=== bts-sio-cyber-lab : état ==="
if [[ "$PID" =~ ^[0-9]+$ ]] && kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o args= 2>/dev/null | grep -Fq "$ROOT/scripts/auto-audit.sh"; then
  echo "Superviseur : ACTIF (PID $PID)"
else
  echo "Superviseur : ARRETE"
fi

if curl -sSf --max-time 2 http://127.0.0.1:3000 >/dev/null 2>&1; then
  echo "Application : HTTP 200/OK sur 127.0.0.1:3000"
else
  echo "Application : indisponible sur 127.0.0.1:3000"
fi

echo "Rapports :"
find "$ROOT/reports" -maxdepth 1 -type f -printf '  - %f\n' 2>/dev/null | sort
