# Memoria compartida y registro de trabajos

Estado: implementación inicial, 2026-11-06. Extiende el plugin existente; no requiere un servidor propio ni reemplaza Markdown/Obsidian. La bitácora productiva se configura en el repo privado elegido por el equipo.

## Un dato, un propósito

| Capa | Qué responde | Fuente |
|---|---|---|
| Estado vigente | Qué sabemos hoy y qué sigue | INDEX/TLDR del proyecto |
| Decisiones | Por qué se eligió ese camino | team/decisions |
| Entregas | Quién hizo qué, en qué PR y con qué validación | Issue del proyecto, comentarios por entrega |
| Detalle | Cómo se llegó al resultado | Sesión del participante |
| Implementación | Qué código realmente se integró | PR, commit y checks de GitHub |

La bitácora enlaza la sesión; el TLDR enlaza decisiones y entregas relevantes. No copiar la misma narración en tres sitios. El autor de GitHub no identifica por sí solo a Codex, Claude u otro agente: el post lleva `participant` y `agent` separados. Los estados del post describen el momento de publicación, no sustituyen consultar la PR actual.

## Ciclo

1. Leer el INDEX/TLDR del proyecto explícito. Abrir sólo decisiones relevantes y memoria propia necesaria.
2. Trabajar en el repo de código y validar el resultado.
3. Guardar sesión propia y actualizar estado vigente si cambió. Sincronizar y comprobar publicación.
4. Publicar resumen con tarea estable, participante, agente, PR/commit, validación y sesión. Si cambia el commit o se integra la PR, agregar una nueva entrada.
5. Guardar el enlace en el índice propio. Para retomar, leer estado corto; consultar la bitácora sólo ante preguntas de entregas o cambios del equipo.

Se usa un Issue por proyecto para cumplir la necesidad de un único posteo de trabajos. Los comentarios evitan que cada agente tenga que reescribir una descripción compartida. No se usan `Closes #...` hacia la bitácora. Un proyecto muy activo puede rotarla por evento o período con enlaces explícitos entre Issues.

## Ahorro de tokens: hipótesis y medición

El ahorro viene de limitar lo que entra al modelo, no de almacenar menos evidencia. INDEX/TLDR de 300–500 palabras como objetivo; entradas cortas con límites de longitud; consultas con fecha, participante y máximo 10 resultados por defecto. La paginación ocurre en Python y sólo los resúmenes llegan al agente. Se informa truncamiento y no se avanza un cursor silenciosamente.

Medir en tareas equivalentes: tokens de entrada usados para recuperar contexto, cantidad de notas/PRs abiertas, tiempo de recuperación y decisiones erróneas por contexto faltante. Comparar lectura habitual de sesiones frente a TLDR + búsqueda dirigida. No hay ahorro porcentual medido todavía. El grafo del código es un complemento opcional para dependencias; el grafo de ideas sirve para investigación. Ninguno debe cargarse entero para cada tarea.

## Incorporación y concurrencia

El HUB instala el plugin, crea el cerebro privado, invita cuentas explícitas, registra ids estables con cuenta GitHub y configura proyecto/repos de código/bitácora. El participante acepta acceso, usa su propia cuenta, instala las cuatro skills, valida sync y ejecuta doctor. La configuración compartida no contiene rutas personales ni secretos. No cambiar identidades históricas al editar un nombre visible.

La selección por repositorio gana sobre un env global de otro equipo. El setup actual mantiene su autosync con TTL. Publicar comentarios tiene claves para reintentos normales; GitHub no ofrece aquí un insert único por clave: un único escritor por tarea/agente y revisión explícita de duplicados concurrentes. Si GitHub falla, conservar el JSON pendiente y repetir; la memoria sincronizada sigue disponible.

El helper no certifica la calidad de las pruebas ni comprueba por sí mismo que la sesión llegó al remoto: el cierre debe comprobarlo. `doctor` verifica acceso al Issue; identidad, instalación y sync se verifican además. No se incorporaron webhooks ni workflows que puedan ejecutar contenido recibido desde Issues.

## Base de la investigación

- [Comentarios de Issues, API oficial](https://docs.github.com/en/rest/issues/comments): creación, paginación y filtro `since` permiten publicar y recuperar incrementos.
- [Invitar colaboradores, GitHub](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/inviting-collaborators-to-a-personal-repository): invitar y aceptar son pasos separados; el enlace al plugin no concede acceso al cerebro privado.
- [Propuesta externa fijada a commit](https://github.com/Voyager-Ov/cerebro-propuesta/tree/283174d): inspiración del grafo y prototipos, conservada como propuesta.
