#!/usr/bin/env bash
# Instala la skill cerebro-compartido directamente desde este repo a los
# directorios de skills de los agentes instalados. No requiere un cerebro.
set -euo pipefail
SOURCE_ROOT="$(cd "$(dirname "$0")/skills" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

for DEST_ROOT in "$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.gemini/config/skills"; do
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

echo "Skill instalada. Para crear un cerebro nuevo segui el Quickstart del README."
