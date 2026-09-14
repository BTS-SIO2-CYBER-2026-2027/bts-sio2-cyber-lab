#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="$ROOT/.lab-state"
mkdir -p "$STATE_DIR"
PID_FILE="$STATE_DIR/auto-audit.pid"
OUT="$STATE_DIR/auto-audit.log"

if [[ -f "$PID_FILE" ]]; then
  PID="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [[ "$PID" =~ ^[0-9]+$ ]] && kill -0 "$PID" 2>/dev/null; then
    echo "Superviseur automatique déjà actif (PID $PID)."
    exit 0
  fi
fi

nohup bash "$ROOT/scripts/auto-audit.sh" >>"$OUT" 2>&1 &
PID=$!
echo "$PID" > "$PID_FILE"
echo "Superviseur automatique démarré (PID $PID)."
echo "Journal : .lab-state/auto-audit.log"
