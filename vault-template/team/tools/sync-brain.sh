#!/usr/bin/env bash
set -euo pipefail

BRAIN_ROOT="${BRAIN_ROOT:-$HOME/SharedBrain}"
PARTICIPANT_ID="${PARTICIPANT_ID:-}"
MESSAGE="${1:-}"

[ -n "$PARTICIPANT_ID" ] || { echo "Falta PARTICIPANT_ID." >&2; exit 2; }
[ -d "$BRAIN_ROOT/.git" ] || { echo "No hay repositorio Git en $BRAIN_ROOT" >&2; exit 2; }
[ ! -d "$BRAIN_ROOT/.git/rebase-merge" ] || { echo "Hay un rebase pendiente." >&2; exit 2; }

git -C "$BRAIN_ROOT" add -A
if ! git -C "$BRAIN_ROOT" diff --cached --quiet; then
  [ -n "$MESSAGE" ] || MESSAGE="brain: $PARTICIPANT_ID $(date '+%Y-%m-%d %H:%M:%S')"
  git -C "$BRAIN_ROOT" commit -m "$MESSAGE"
fi

if ! git -C "$BRAIN_ROOT" pull --rebase origin main; then
  echo "Pull/rebase detenido. Resolver sin reset --hard ni push --force." >&2
  exit 2
fi

for attempt in 1 2; do
  if git -C "$BRAIN_ROOT" push origin main; then
    echo "Shared Brain sincronizado por $PARTICIPANT_ID."
    exit 0
  fi
  if [ "$attempt" = 1 ]; then
    git -C "$BRAIN_ROOT" pull --rebase origin main || {
      echo "Otro cambio genero un conflicto. Resolverlo manualmente." >&2
      exit 2
    }
  fi
done

echo "No se pudo publicar despues de dos intentos." >&2
exit 1
