#!/usr/bin/env bash
set -euo pipefail

BRAIN_ROOT="${BRAIN_ROOT:-$HOME/SharedBrain}"
HACKATHON_ENDS="${HACKATHON_ENDS:-}"

if [ -n "$HACKATHON_ENDS" ]; then
  END_DATE="${HACKATHON_ENDS:0:10}"
  if [ "$(date +%F)" \> "$END_DATE" ]; then
    ( crontab -l 2>/dev/null | grep -v 'autosync-brain.sh' || true ) | crontab -
    echo "El hackaton termino ($HACKATHON_ENDS): autosync desinstalado."
    exit 0
  fi
fi

exec bash "$BRAIN_ROOT/team/tools/sync-brain.sh"
