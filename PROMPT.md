# Prompt de instalación — para cualquier agente

Si tu agente no tiene instalador de plugins ni skills (Devin, Gemini, o el que sea), cloná este repo y pegale esto:

---

Cloné el repo `cerebro-compartido`: un plugin de memoria de equipo para hackatones. Instalámelo y dejalo listo para usar.

1. Leé `skills/cerebro-setup/SKILL.md`, `skills/cerebro-leer/SKILL.md` y `skills/cerebro-cierre/SKILL.md` para entender el contrato.
2. Instalá las 3 skills en mi entorno:
   - Si este agente tiene un directorio de skills (ej. `~/.codex/skills`, `~/.claude/skills`, `~/.agents/skills`, o `.devin/skills` del proyecto), enlazá o copiá cada `skills/<nombre>` ahí.
   - Si no sabés cuál es, ejecutá `install.sh` (macOS/Linux) o `install.ps1` (Windows) desde la raíz del repo: enlaza las skills a los directorios conocidos.
3. Cuando estén instaladas, corré `cerebro-setup`: haceme las preguntas de `skills/cerebro-setup/references/preguntas.md` de a una y seguí el flujo según mis respuestas.

---
