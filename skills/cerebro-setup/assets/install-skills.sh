#!/usr/bin/env bash
set -euo pipefail
BRAIN_ROOT="${1:-${BRAIN_ROOT:-$HOME/SharedBrain}}"
SOURCE_ROOT="$BRAIN_ROOT/team/skills"
[ -d "$SOURCE_ROOT" ] || { echo "Las skills aun no estan sincronizadas en $SOURCE_ROOT" >&2; exit 1; }
STAMP="$(date +%Y%m%d-%H%M%S)"

for DEST_ROOT in "$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.gemini/config/skills"; do
  mkdir -p "$DEST_ROOT"
  for SOURCE in "$SOURCE_ROOT"/*; do
    [ -d "$SOURCE" ] || continue
    NAME="$(basename "$SOURCE")"
    DEST="$DEST_ROOT/$NAME"
    if [ -L "$DEST" ]; then
      ln -sfn "$SOURCE" "$DEST"
      echo "OK: enlace actualizado $DEST -> $SOURCE"
      continue
    fi
    if [ -e "$DEST" ]; then
      mv "$DEST" "$DEST.backup-$STAMP"
      echo "Backup: $DEST.backup-$STAMP"
    fi
    ln -s "$SOURCE" "$DEST"
    echo "Enlace: $DEST -> $SOURCE"
  done
done
