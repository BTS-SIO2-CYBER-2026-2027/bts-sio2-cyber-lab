#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib.sh"
load_lab_env

STATE_DIR="$ROOT/.lab-state"
mkdir -p "$STATE_DIR" "$ROOT/reports"
LAST_HASH_FILE="$STATE_DIR/last-audited-hash"
APP_PID_FILE="$STATE_DIR/app.pid"
LOG_FILE="$STATE_DIR/app.log"
DEBOUNCE="${AUTO_AUDIT_DEBOUNCE_SECONDS:-12}"

hash_app() {
  find "$ROOT/app" -type f ! -name '.gitkeep' -print0 2>/dev/null \
    | sort -z \
    | xargs -0 -r sha256sum 2>/dev/null \
    | sha256sum | awk '{print $1}'
}

app_has_files() {
  find "$ROOT/app" -type f ! -name '.gitkeep' -print -quit | grep -q .
}

stop_previous_app() {
  if [[ -f "$APP_PID_FILE" ]]; then
    PID="$(cat "$APP_PID_FILE" 2>/dev/null || true)"
    if [[ "$PID" =~ ^[0-9]+$ ]] && kill -0 "$PID" 2>/dev/null; then
      kill "$PID" 2>/dev/null || true
      sleep 1
      kill -9 "$PID" 2>/dev/null || true
    fi
  fi
}

wait_for_app() {
  for _ in $(seq 1 60); do
    if curl --silent --fail --max-time 2 "$APP_URL" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  return 1
}

run_audit_cycle() {
  local hash="$1"
  echo "[$(date '+%H:%M:%S')] Code généré détecté. Préparation de l'application..."
  stop_previous_app
  : > "$LOG_FILE"

  set +e
  "$ROOT/scripts/start-generated-app.sh" >"$LOG_FILE" 2>&1 &
  APP_PID=$!
  set -e
  echo "$APP_PID" > "$APP_PID_FILE"

  if ! wait_for_app; then
    echo "[$(date '+%H:%M:%S')] L'application ne répond pas encore sur $APP_URL."
    echo "Le superviseur réessaiera après la prochaine modification du code."
    echo "Dernières lignes du journal :"
    tail -n 20 "$LOG_FILE" || true
    return 0
  fi

  echo "[$(date '+%H:%M:%S')] Application disponible sur $APP_URL. Audit automatique en cours."

  if [[ "${AUTO_BASELINE_SCAN:-1}" == "1" ]]; then
    "$ROOT/scripts/zap-baseline.sh" || true
  fi
  if [[ "${AUTO_ACTIVE_SCAN:-1}" == "1" ]]; then
    "$ROOT/scripts/zap-full-scan.sh" --yes || true
  fi

  echo "$hash" > "$LAST_HASH_FILE"
  echo "[$(date '+%H:%M:%S')] Audit terminé. Rapports disponibles dans reports/."
}

echo "Superviseur automatique actif : app/ -> démarrage -> ZAP."
echo "Cible de sécurité verrouillée : $APP_URL"

LAST_SEEN=""
STABLE_SINCE="$(date +%s)"
while true; do
  if ! app_has_files; then
    sleep 3
    continue
  fi

  CURRENT="$(hash_app)"
  NOW="$(date +%s)"
  if [[ "$CURRENT" != "$LAST_SEEN" ]]; then
    LAST_SEEN="$CURRENT"
    STABLE_SINCE="$NOW"
  else
    LAST_AUDITED="$(cat "$LAST_HASH_FILE" 2>/dev/null || true)"
    if [[ "$CURRENT" != "$LAST_AUDITED" ]] && (( NOW - STABLE_SINCE >= DEBOUNCE )); then
      run_audit_cycle "$CURRENT"
      # Empêche de relancer en boucle sur un code non exécutable inchangé.
      echo "$CURRENT" > "$LAST_HASH_FILE"
    fi
  fi
  sleep 3
done
