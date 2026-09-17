# Instalar skills del equipo

La fuente canónica es `<BRAIN_ROOT>/team/skills/`.

- Windows: ejecutar `infra/windows/install-skills.ps1` desde el kit.
- macOS: ejecutar `infra/macos/install-skills.sh`.

Los instaladores se ejecutan después de clonar el repositorio y crean enlaces hacia el vault en `~/.codex/skills/` y `~/.claude/skills/`; si un enlace no es posible, copian la skill. Nunca sobrescriben una skill local distinta sin guardar primero una copia de respaldo.
