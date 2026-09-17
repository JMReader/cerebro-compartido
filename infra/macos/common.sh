#!/usr/bin/env bash
set -euo pipefail

install_apps() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Falta Homebrew. Instalar desde https://brew.sh y volver a ejecutar."
    return 1
  fi
  brew list --cask obsidian >/dev/null 2>&1 || brew install --cask obsidian
  command -v git >/dev/null 2>&1 || brew install git
  command -v gh >/dev/null 2>&1 || brew install gh
}

set_brain_env() {
  local brain_root="$1"
  local participant_id="$2"
  local env_file="$HOME/.cerebro/shared-brain.env"
  mkdir -p "$HOME/.cerebro"
  {
    printf 'export BRAIN_ROOT=%q\n' "$brain_root"
    printf 'export PARTICIPANT_ID=%q\n' "$participant_id"
    [ -n "${HACKATHON:-}" ] && printf 'export HACKATHON=%q\n' "$HACKATHON"
    [ -n "${HACKATHON_ENDS:-}" ] && printf 'export HACKATHON_ENDS=%q\n' "$HACKATHON_ENDS"
  } > "$env_file"
  grep -Fq 'shared-brain.env' "$HOME/.zshrc" 2>/dev/null || printf '\n[ -f "$HOME/.cerebro/shared-brain.env" ] && source "$HOME/.cerebro/shared-brain.env"\n' >> "$HOME/.zshrc"
  export BRAIN_ROOT="$brain_root"
  export PARTICIPANT_ID="$participant_id"
}

copy_new_only() {
  local source="$1"
  local destination="$2"
  mkdir -p "$destination"
  cp -Rn "$source"/. "$destination"/
}
