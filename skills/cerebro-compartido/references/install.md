# Instalar skills del equipo

La fuente canónica dentro de un cerebro es `<BRAIN_ROOT>/team/skills/`.

- Windows: ejecutar `infra/windows/install-skills.ps1` desde el kit.
- macOS: ejecutar `infra/macos/install-skills.sh`.

Los instaladores se ejecutan después de clonar el repositorio del cerebro y crean enlaces hacia el vault en `~/.codex/skills/` y `~/.claude/skills/`; si un enlace no es posible, copian la skill. Nunca sobrescriben una skill local distinta sin guardar primero una copia de respaldo.

Para instalar la skill sin cerebro (standalone), ejecutar `install.sh` o `install.ps1` en la raíz del kit: enlaza `skills/` del repo a los directorios de skills de los agentes. En Claude Code también se puede agregar como plugin con `/plugin marketplace add JMReader/cerebro-compartido` e instalar el plugin `cerebro-compartido`.
