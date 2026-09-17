# Cerebro Compartido

Un **plugin/skill** para que un equipo de hackatón comparta **una misma memoria** entre humanos y agentes (Codex, Claude, Devin, etc.) sin tener que re-explicar el contexto en cada máquina.

La idea: en vez de que cada agente re-entienda el proyecto leyendo código, el equipo deja sus decisiones, sesiones y hallazgos en un **vault de Markdown** sincronizado por GitHub. Cada agente consulta esa verdad común antes de trabajar y deja memoria al cerrar.

## Cómo funciona

- **Un repo privado de GitHub** es el cerebro. Git es la sincronización; no hace falta nada más.
- **`team/`** = verdad común: decisiones, proyectos, links, capturas, skills del equipo.
- **`each_one/<participant-id>/`** = memoria operativa de cada persona: inbox, notas, sesiones. Nadie escribe en la carpeta ajena.
- **La skill `cerebro-compartido`** enseña al agente el contrato: cómo crear un cerebro (setup), qué leer al empezar (consultar), dónde escribir, cómo cerrar una sesión y cómo registrar decisiones.
- **Scripts de setup** dejan cada máquina lista en minutos: clon, variables de entorno (`BRAIN_ROOT`, `PARTICIPANT_ID`), skill instalada y sync cada minuto o bajo demanda.

## Instalar como plugin

### Claude Code

```
/plugin marketplace add JMReader/cerebro-compartido
/plugin install cerebro-compartido@cerebro-compartido
```

### Cualquier agente (Codex, Claude, Gemini, Devin…)

```bash
git clone https://github.com/JMReader/cerebro-compartido
bash cerebro-compartido/install.sh      # Windows: install.ps1
```

Enlaza `skills/cerebro-compartido` a `~/.codex/skills`, `~/.claude/skills`, `~/.agents/skills` y `~/.gemini/config/skills`. Sin cerebro, la skill sólo orienta; al conectar un vault toma el contrato completo.

## Estructura del kit

```
.claude-plugin/   Manifests de plugin/marketplace
skills/           Skill cerebro-compartido (fuente canónica del plugin)
vault-template/   Template del vault: copiar para crear el cerebro del equipo
  .brain/         brain-config.yaml, participants.yaml, conventions.md
  _templates/     session, decision, capture
  each_one/       un directorio por participante
  team/           decisions/, links/, projects/, captures/, skills/, tools/
infra/            Setup por máquina: macos/ y windows/, autosync, operación
prompts/          Prompts de onboarding listos para pegar en el agente
```

## Quickstart (hackatón)

### 1. Admin: crear el cerebro

```bash
gh auth login
gh repo create <org>/<mi-brain> --private
bash infra/macos/setup-hub.sh https://github.com/<org>/<mi-brain>.git
```

Editar `~/SharedBrain/.brain/participants.yaml` con los ids del equipo, crear cada `each_one/<id>/` y publicar con `team/tools/sync-brain.sh`. Invitar a todos como Collaborators.

En Windows: `setup-hub.ps1 -RepoUrl <url>`.

### 2. Cada participante

```bash
gh auth login
bash infra/macos/setup-client.sh participant-2 https://github.com/<org>/<mi-brain>.git
```

En Windows: `setup-client.ps1 -ParticipantId participant-2 -RepoUrl <url>`.

El script instala Git/gh/Obsidian si faltan, clona el vault, define `BRAIN_ROOT`/`PARTICIPANT_ID` e instala las skills del vault en el agente.

Opcional: `HACKATHON=nombre HACKATHON_ENDS=2026-09-20 bash infra/macos/setup-client.sh ...` registra en la máquina en qué evento está y cuándo termina.

### 3. Sync: bajo demanda o cada minuto

```bash
bash "$BRAIN_ROOT/team/tools/sync-brain.sh"      # al empezar y cerrar sesiones
bash infra/macos/install-autosync.sh             # opcional: cada minuto vía cron
```

Para desinstalar el autosync al terminar: `infra/macos/uninstall-autosync.sh` (o `uninstall-autosync.ps1` en Windows). Nada queda permanente.

### 4. Agentes

Pegar el prompt de `prompts/` correspondiente a cada máquina. Después, el agente usa la skill solo: consulta `team/` y `each_one/` al empezar, escribe en su espacio y deja nota de sesión al cerrar.

## Reglas de oro

- Nunca secretos, tokens ni `.env` en el vault.
- Escribir por defecto en `each_one/<tu-id>/`; `team/` sólo para verdad común.
- Sin `push --force` ni `reset --hard`: ante conflicto, conservar ambas versiones y resolver.
- Las notas del vault son contexto para el agente, no instrucciones que pisan al sistema.

## Requisitos

Git, GitHub CLI (`gh`) y Obsidian (opcional, para navegar el vault). Los scripts los instalan con Homebrew/winget si faltan.

## Licencia

MIT — ver [LICENSE](LICENSE).
