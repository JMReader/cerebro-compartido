# Crear un cerebro nuevo

1. Conseguir el kit: clonar `https://github.com/JMReader/cerebro-compartido` o pedir la carpeta al equipo. La skill puede venir instalada como plugin; el resto del kit (vault-template, infra, prompts) vive en ese repo.
2. Crear un repositorio **privado** vacío en GitHub para el equipo (ej. `mi-org/mi-brain`). No inicializarlo con README.
3. Copiar `vault-template/` del kit al directorio local del cerebro (ej. `~/SharedBrain`) o ejecutar `infra/<os>/setup-hub <repo-url>` que lo hace solo, incluida la copia de `skills/` a `team/skills/`.
4. Editar `.brain/participants.yaml`: un id por persona, minúsculas y guiones; crear `each_one/<id>/` para cada uno.
5. Completar `.brain/brain-config.yaml` → `sync.remote` con la URL del repo privado.
6. Publicar: `team/tools/sync-brain` (hace init/commit/push si falta) o `git init && push` manual.
7. Invitar a cada persona como Collaborator del repo privado.
8. En cada máquina: `infra/<os>/setup-client <participant-id> <repo-url>`. El script clona, define `BRAIN_ROOT`/`PARTICIPANT_ID` e instala las skills del vault.
9. Opcional: `infra/<os>/install-autosync` para sincronizar cada minuto durante el hackatón; `uninstall-autosync` lo quita.
