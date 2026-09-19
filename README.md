# Cerebro Compartido

Un plugin para que tu equipo de hackatón comparta **una misma memoria** entre humanos y agentes.

El cerebro es un repo privado de GitHub con Markdown: `team/` guarda la verdad común (decisiones, proyectos, links) y `each_one/<vos>/` guarda tu trabajo. Los agentes leen de ahí antes de trabajar y escriben ahí al terminar — nadie re-explica el proyecto dos veces.

## Usarlo

1. Instalá el plugin en tu agente:

   ```
   # Claude Code
   /plugin marketplace add JMReader/cerebro-compartido
   /plugin install cerebro-compartido@cerebro-compartido

   # cualquier otro agente
   git clone https://github.com/JMReader/cerebro-compartido
   bash cerebro-compartido/install.sh
   ```

   ¿Tu agente no tiene instalador? Cloná el repo y pegale el prompt de [PROMPT.md](PROMPT.md) — se instala solo.

2. Decile a tu agente: **"corré cerebro-setup"**. Te hace 5 preguntas y deja todo listo: el cerebro privado, la invitación a tus compañeros, el repo del proyecto y el sync automático (que se apaga solo cuando termina el hackatón).

3. Trabajá normal. Y **cuando termines una tarea, recordale a tu agente: "cerrá esto con cerebro-cierre"** — guarda todo en tu INDEX del cerebro y la próxima tarea arranca con contexto en vez de re-descubrirlo (menos tokens).

## Ejemplos de lo que le podés pedir a tu agente

- "¿Qué hizo Nano en la última media hora para la hacka? Fijate y actualizame el código"
- "Che, ¿qué habíamos dicho que íbamos a hacer hace 4 horas en la definición de la tarea?"
- "Actualizame el vault con todo lo de hasta ahora porfa"
- "Fijate en memoria si hay alguna discrepancia entre lo que hice yo y lo que dijo Octa"

## Las 3 skills

| Skill | Cuándo | Qué hace |
|-------|--------|----------|
| `cerebro-setup` | Una vez por máquina | 5 preguntas → cerebro privado + equipo invitado + repo del proyecto + autosync con TTL |
| `cerebro-leer` | Antes de trabajar | Trae el contexto vigente: qué está vigente, próximo paso, bloqueos |
| `cerebro-cierre` | Al terminar tarea/spec/feature o tomar una decisión | Deja memoria en tu INDEX para la próxima sesión |

## Reglas de oro

- Nunca secretos ni `.env` en el cerebro
- Escribís en `each_one/<tu-id>/`; `team/` sólo para verdad común
- Sin `push --force`: ante conflicto se conservan ambas versiones

MIT — ver [LICENSE](LICENSE).
