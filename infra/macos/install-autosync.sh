#!/usr/bin/env bash
set -euo pipefail
BRAIN_ROOT="${BRAIN_ROOT:-$HOME/SharedBrain}"
PARTICIPANT_ID="${PARTICIPANT_ID:-}"

[ -n "$PARTICIPANT_ID" ] || { echo "Falta PARTICIPANT_ID. Ejecuta setup-client primero." >&2; exit 2; }
[ -f "$BRAIN_ROOT/team/tools/sync-brain.sh" ] || { echo "No se encontro sync-brain.sh en $BRAIN_ROOT" >&2; exit 2; }

mkdir -p "$HOME/.cerebro"
LOG="$HOME/.cerebro/autosync.log"
LINE="* * * * * BRAIN_ROOT='$BRAIN_ROOT' PARTICIPANT_ID='$PARTICIPANT_ID' bash '$BRAIN_ROOT/team/tools/sync-brain.sh' >> '$LOG' 2>&1"

( crontab -l 2>/dev/null | grep -v 'sync-brain.sh' || true; echo "$LINE" ) | crontab -
echo "Autosync instalado: sync-brain.sh cada minuto. Log: $LOG"
echo "Para quitarlo al terminar el hackaton: bash $(dirname "$0")/uninstall-autosync.sh"
