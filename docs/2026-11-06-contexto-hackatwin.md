# Contexto para retomar el proyecto

Fecha: 2026-11-06. Autor: Codex, solicitado por JMReader. Estado: investigación y preparación; el producto de mañana aún no fue definido por el usuario. Este archivo se guarda en el repo del plugin, sin escribir en el cerebro histórico de TERRIA ni en el vault de Lazo.

## Pedido conservado

Mejorar el segundo cerebro manteniéndolo como plugin, agregar un posteo común de trabajos terminados por agente en GitHub Issues, enlazar cada entrega a su PR y compartir contexto con menos tokens. Conservar invitación e incorporación del equipo. Revisar lo hecho por Iocta en Voyager-Ov/cerebro-propuesta para decidir el trabajo del día siguiente.

## Participación anterior: evidencia

En JMReader/cerebro-compartido hay cuatro commits con autor Git `Juan manuel coro Reader`: kit inicial (`0ef99e0`), conversión a plugin (`4251096`), separación setup/leer/cierre (`cc3d3c8`) e instalación por prompt (`0b44e71`). GitHub no vincula esos commits a una cuenta en su campo `author`; la atribución es la identidad grabada en Git, no una inferencia sobre agentes usados. La base relevante para esta mejora es el plugin compartido, no el plugin personal de otro proyecto.

Se inspeccionaron las skills y la configuración del cerebro anterior: `JMReader/shared-brain` es privado, contiene TERRIA y registra `participant-4` con nombre korita. La configuración global local apunta al vault de Lazo y a `juanma`, que no coincide con ese registro. No se modificó esa configuración ni se escribió como otro participante. Falta elegir cerebro nuevo para HackaTwin o reutilizar explícitamente el anterior e identidad; se consultó al usuario.

## Referencia de Iocta

Repo: [Voyager-Ov/cerebro-propuesta](https://github.com/Voyager-Ov/cerebro-propuesta). Snapshot inspeccionado: [`283174d`](https://github.com/Voyager-Ov/cerebro-propuesta/commit/283174d6586be31c0304f5c2fc4391376b7b90aa). Autor de los cuatro commits observados: Voyager-Ov. Copia local de consulta: `/Users/korita/work/cerebro/cerebro-propuesta`.

Contiene investigación enlazada en Markdown, prototipos visuales y un frontend. Rutas para abrir según la necesidad:

- `docs/cerebro/nodos/ID09-escrow-acceptance-criteria-smart-contract.md`: CriteriaLock, propuesta de custodia condicionada.
- `docs/cerebro/nodos/ID10-vibe-brand-os-personal-presence.md`: VibeOS, propuesta de presencia profesional.
- `docs/cerebro/nodos/AR09-codebase-memory-mcp-knowledge-graph.md`: propuesta de grafo del código. Sus herramientas, instalación y cifras de ahorro requieren verificación independiente antes de adoptarlas.
- `specs/frontend/bloqueo-plata-landing/`: especificación de interfaz y lista de trabajo.
- `frontend/src/components/CriteriaLockCard.tsx`, `frontend/src/app/page.tsx` y `demo/`: puntos de entrada para evaluar la demostración visual.

No se ejecutaron dependencias, scripts ni código del repo externo. No se validó un flujo de custodia real, contratos desplegados o integraciones financieras. Claims técnicos/comerciales del material son propuestas del autor; requieren verificación antes de usarse como hechos o criterios cumplidos. El README y el índice dan cifras distintas del grafo: no usar esas cifras como estado operativo.

## Lo preparado hoy y cómo retomarlo

Rama `feat/worklog-memoria-equipo` en JMReader/cerebro-compartido: cuarta skill cerebro-postear, helper Python/gh, cierre y lectura conectados a bitácora, configuración por proyecto y comprobación de acceso. El diseño está en `docs/memoria-y-trabajos.md`. La PR de esta rama es el punto revisable de implementación; no implica instalación ni rollout a participantes.

Para mañana: recibir la definición de producto del usuario; elegir cerebro/proyecto e identidad explícitos; acordar participantes por sus cuentas GitHub; revisar el diff del plugin e inicializar la bitácora en el cerebro elegido. No asumir que CriteriaLock o VibeOS ya fueron elegidos. No convertir la instalación de un indexador MCP en requisito para empezar.
