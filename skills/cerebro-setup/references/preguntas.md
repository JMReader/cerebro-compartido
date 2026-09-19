# Guion de preguntas

Hacer las preguntas de a una, en orden. No asumir respuestas ni crear archivos antes de conocer la rama.

## Siempre

1. **"¿Sos el primero en configurar el cerebro del equipo, o ya lo creó un compañero?"**
   - Primero → rama HUB. Compañero → rama COMPAÑERO.
2. **"¿Ya existe el repositorio del proyecto del hackatón en GitHub?"**
   - Si sí → pedir la URL.
3. **"¿Cómo te identifican en el equipo?"**
   - Alias en minúsculas y guiones (`juan-perez`). Será su `PARTICIPANT_ID` y su carpeta `each_one/<alias>/`.
4. **"¿Cuánto dura el hackatón?"**
   - Guardar la fecha/hora de fin en formato ISO (`YYYY-MM-DD` o `YYYY-MM-DDTHH:MM`) como `HACKATHON_ENDS`.
5. **"¿Cada cuántos minutos querés sincronizar el cerebro?"**
   - Entero entre 1 y 59. Sugerir 5.

## Sólo si es HUB

- **"Pasame los usuarios de GitHub de todos tus compañeros."** Se usan como id provisorio en `participants.yaml` y para invitarlos como colaboradores del repo privado.
- Si el repo del proyecto no existe:
  - **"¿Qué nombre le ponemos al repo?"**
  - Recomendar monolito: front y back en el mismo repositorio.
  - **"¿Qué stack de backend y frontend van a usar?"**

## Sólo si es COMPAÑERO

- **"¿Cuál es la URL del repo privado del cerebro?"** (la consigue de quien lo creó).
- **"¿Cuál es tu usuario de GitHub?"** para buscar `each_one/<github-user>` y renombrarla a su alias.
