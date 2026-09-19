#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRAIN_ROOT="${BRAIN_ROOT:-$HOME/SharedBrain}"
PARTICIPANT_ID="${PARTICIPANT_ID:-}"
HACKATHON_ENDS="${HACKATHON_ENDS:-}"
MINUTES="${1:-5}"

[ -n "$PARTICIPANT_ID" ] || { echo "Falta PARTICIPANT_ID. Ejecuta cerebro-setup primero." >&2; exit 2; }
[ -f "$BRAIN_ROOT/team/tools/sync-brain.sh" ] || { echo "No se encontro sync-brain.sh en $BRAIN_ROOT" >&2; exit 2; }
{ [[ "$MINUTES" =~ ^[0-9]+$ ]] && [ "$MINUTES" -ge 1 ] && [ "$MINUTES" -le 59 ]; } || { echo "Intervalo invalido: $MINUTES (1 a 59 minutos)." >&2; exit 2; }

mkdir -p "$HOME/.cerebro"
LOG="$HOME/.cerebro/autosync.log"
LINE="*/$MINUTES * * * * BRAIN_ROOT='$BRAIN_ROOT' PARTICIPANT_ID='$PARTICIPANT_ID' HACKATHON_ENDS='$HACKATHON_ENDS' bash '$SCRIPT_DIR/autosync-brain.sh' >> '$LOG' 2>&1"

( crontab -l 2>/dev/null | grep -v 'autosync-brain.sh' || true; echo "$LINE" ) | crontab -
echo "Autosync instalado: sync cada $MINUTES minutos. Log: $LOG"
echo "Se desinstala solo cuando pasa HACKATHON_ENDS='$HACKATHON_ENDS'. Manual: bash $SCRIPT_DIR/uninstall-autosync.sh"
