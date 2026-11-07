---
name: cerebro-cierre
description: Cerrar una tarea, spec, feature o decisión dejando memoria en el cerebro compartido — nota de sesión, INDEX actualizado y decisión del equipo si aplica — para que la próxima tarea arranque sin re-descubrir contexto.
---

# Cerrar y dejar memoria

Invocar al terminar una tarea, spec o feature, o cuando se toma una decisión. El objetivo es que la próxima sesión arranque desde el INDEX en vez de re-descubrir contexto (ahorra tokens).

Resolver primero cerebro, proyecto y participante según `cerebro-leer`; validar registro y no usar el env de otro equipo.

## Pasos

1. Sync primero con `team/tools/sync-brain.sh` (macOS) o `sync-brain.ps1` (Windows).
2. Crear `each_one/<participant-id>/sessions/YYYY-MM-DD-<tema>.md` desde `_templates/session.md`: qué se hizo, decisiones, pendientes y links. Si ya existe el archivo, agregar sufijo horario; nunca sobrescribir.
3. Actualizar `each_one/<participant-id>/INDEX.md` con el estado actual y el enlace a la sesión.
4. Si se tomó una decisión del equipo: crear `team/decisions/YYYY-MM-DD-<slug>.md` desde `_templates/decision.md` y agregar UNA fila a `team/decisions/INDEX.md` (releerlo justo antes de editar). Si reemplaza una decisión previa, marcarla `superseded` y enlazar ambas; no borrarla.
5. Si cambió el estado común, releer y actualizar el INDEX/TLDR del proyecto con resultado, próximo paso y enlaces. Mantenerlo corto; no pegar la sesión completa ni promover una propuesta externa a decisión sin acuerdo.
6. Sync final con `team/tools/sync-brain`. Verificar el commit remoto antes de enlazar la sesión.
7. Si existe `.brain/worklogs/<project>.json`, usar `cerebro-postear` para publicar la entrega y evidencia. Registrar por separado participante y agente. PR abierta = en revisión; PR merged = integrado. Si falta PR para documentación, usar un commit publicado y motivo explícito. Enlazar la entrada desde el INDEX propio y sincronizar. Si falla la publicación, dejar entrada pendiente en el inbox propio; no declarar el cierre publicado.

## Reglas

- Escribir sólo en el `each_one/` propio, salvo decisiones comunes en `team/decisions/`.
- CREATE > UPDATE > DELETE: crear notas nuevas antes que modificar compartidas.
- Ante conflicto de Git, conservar ambas versiones y resolver explícitamente; nunca `push --force` ni `reset --hard`.
- Nunca guardar secretos, tokens, credenciales ni archivos `.env`.
- Reportar rutas modificadas y el commit publicado.
