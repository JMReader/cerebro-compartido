# Crear un cerebro nuevo

1. Crear un repositorio **privado** vacío en GitHub para el equipo (ej. `mi-org/mi-brain`). No inicializarlo con README.
2. Copiar `vault-template/` del kit al directorio local del cerebro (ej. `~/SharedBrain`) o ejecutar `infra/<os>/setup-hub` que lo hace solo.
3. Editar `.brain/participants.yaml`: un id por persona, minúsculas y guiones; crear `each_one/<id>/` para cada uno.
4. Completar `.brain/brain-config.yaml` → `sync.remote` con la URL del repo privado.
5. Publicar: `team/tools/sync-brain` (hace init/commit/push si falta) o `git init && push` manual.
6. Invitar a cada persona como Collaborator del repo privado.
7. En cada máquina: `infra/<os>/setup-client <participant-id> <repo-url>`. El script clona, define `BRAIN_ROOT`/`PARTICIPANT_ID` e instala las skills del vault.
8. Opcional: `infra/<os>/install-autosync` para sincronizar cada minuto durante el hackatón; `uninstall-autosync` lo quita.
