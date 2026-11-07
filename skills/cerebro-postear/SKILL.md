---
name: cerebro-postear
description: Registrar entregas de agentes en la bitácora de GitHub Issues del cerebro, enlazando participante, tarea, PR y memoria. Consultar qué entregó el equipo sin cargar sesiones completas.
---

# Bitácora del equipo

Un Issue por proyecto en el repo privado del cerebro; un comentario por entrega, agente y estado observado de la PR. La persona es `participant`; la herramienta es `agent`. No inferir que el autor de una PR identifica al agente.

Resolver cerebro, proyecto e identidad desde la selección explícita de la sesión o el bloque del repositorio. Validar `.brain/brain-config.yaml`, `.brain/participants.yaml` y la carpeta del participante. Si la configuración global apunta a otro cerebro, no usarla silenciosamente.

Usar Python 3 y GitHub CLI autenticado con la cuenta del participante. El helper está en [scripts/worklog.py](scripts/worklog.py); no guarda credenciales. Leer [references/operacion.md](references/operacion.md) para inicializar, publicar o consultar.

Antes de publicar, guardar y sincronizar la sesión en el cerebro y comprobar que su commit llegó al remoto. Pasar un resumen de resultado y validación real, la PR y la ruta relativa a esa sesión. Una PR abierta se registra `en-revision`; una merged, `integrado`. Para documentación o investigación sin PR, admitir un commit publicado con motivo explícito: queda `entregado-sin-pr`, sin atribuirle un merge. No inventar PRs ni afirmar pruebas no ejecutadas.

El helper reutiliza entradas con la misma clave en reintentos normales. No garantiza publicación exactamente una vez ante dos procesos simultáneos: un único escritor por tarea/agente; si aparecen duplicados, conservarlos y enlazar la corrección. Para un nuevo estado o commit, publicar una entrada nueva.

La publicación forma parte del cierre cuando el usuario configuró este flujo para el proyecto. Si falla GitHub, conservar el JSON de entrada en el área propia como pendiente y reintentar explícitamente. No perder la memoria ni declarar publicado lo que falló. No enviar invitaciones ni notificaciones adicionales desde esta skill.
