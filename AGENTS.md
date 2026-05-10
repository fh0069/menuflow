# AGENTS.md — Proyecto MenuFlow

## Contexto

MenuFlow es una app móvil multiplataforma desarrollada con Flutter + Firebase.

Objetivo del producto:

- Gestionar recetas.
- Planificar menús semanales.
- Permitir colaboración familiar.
- Evolucionar tras el TFG hacia producto real y posible monetización.

Stack principal:

- Flutter.
- Dart.
- Riverpod.
- Firebase Authentication.
- Cloud Firestore.
- Firebase Storage.
- Git / GitHub.

Arquitectura obligatoria:

```text
UI → Provider → UseCase → Repository → DataSource → Firebase
```

Estructura:

- `presentation`
- `domain`
- `data`

Regla principal:

> Firebase solo puede usarse en la capa `data`.

---

## Estado actual del proyecto

Funcionalidades implementadas:

- Auth base:
  - Registro.
  - Login.
  - Logout.
- Weekly Plan:
  - Planificación semanal funcional con Firestore.
- Recetas:
  - Crear receta.
  - Consultar recetas.
  - Modificar receta.
  - Eliminar receta.

Fase actual:

- Post-TFG.
- Evolución hacia producto real.
- Prioridad en seguridad, imágenes, familias reales y consolidación técnica.

---

## Prioridades

1. Seguridad.
2. No romper funcionalidades existentes.
3. Arquitectura limpia.
4. Cambios pequeños.
5. No asumir datos no confirmados.
6. Trazabilidad mediante commits claros.
7. Evolución gradual sin refactors globales innecesarios.

---

## Reglas críticas

- No usar Firebase fuera de `data`.
- No inventar colecciones de Firestore.
- No inventar campos de Firestore.
- No cambiar estructura de datos sin autorización.
- No modificar reglas de Firestore/Storage sin explicar impacto.
- No mover lógica sensible al cliente.
- No saltarse use cases.
- No acceder directamente a datasources desde UI.
- No usar estado local para datos persistentes si existe provider.
- No mezclar varias features en un mismo cambio.
- No introducir dependencias sin autorización.
- No hacer refactors globales sin pedirlo.

---

## Arquitectura

Flujo obligatorio:

```text
UI → Provider → UseCase → Repository → DataSource → Firebase
```

Reglas:

- UI no debe contener lógica de Firebase.
- UI no debe contener lógica de negocio.
- Provider gestiona estado y coordina casos de uso.
- UseCase representa una acción de aplicación/dominio.
- Repository define contrato desde `domain`.
- RepositoryImpl vive en `data`.
- DataSource accede a Firebase.
- Models viven en `data`.
- Entities viven en `domain`.
- Entidades de dominio no deben conocer Firebase, JSON ni Flutter.

No permitido:

```text
Widget → Firebase
Widget → DataSource
Provider → Firebase
Domain → Firebase
Entity → Model
```

---

## Flutter

Reglas:

- Mantener arquitectura feature-first.
- Mantener separación por capas.
- No mezclar estado local con Riverpod para datos persistentes.
- No añadir lógica de negocio en widgets.
- No crear pantallas sin confirmar flujo de navegación.
- No añadir dependencias sin autorización.
- No hacer refactors globales sin pedirlo.
- No modificar funcionalidades no relacionadas con la tarea.

Patrón esperado:

```text
Widget/Page → Provider → UseCase → Repository → DataSource → Firebase
```

---

## Firebase

Firebase se usa para:

- Authentication.
- Firestore.
- Storage.

Reglas:

- Firebase Authentication gestiona identidad.
- Firestore gestiona datos persistentes.
- Firebase Storage gestiona imágenes.
- Firebase solo se importa desde `data`.
- No guardar datos inconsistentes por comodidad.
- No ocultar errores importantes con valores por defecto silenciosos.
- No asumir que Firestore está abierto.

---

## Firestore

Colecciones relevantes:

- `users`
- `families`
- `weekly_plans`
- `recipes`

Reglas:

- No inventar colecciones.
- No inventar campos.
- No modificar estructura sin plan.
- Confirmar modelo antes de implementar.
- Evitar duplicidad innecesaria de identificadores.
- Evitar valores por defecto silenciosos en modelos.
- Centralizar validación en capa `data`.

Pendientes técnicos relacionados:

- `D-004-validacion-estricta-firestore`
- `D-005-estrategia-identificadores-firestore`
- `D-008-reglas-firestore`
- `D-010-validacion-estricta-modelos`

---

## Seguridad

La seguridad es prioritaria.

Reglas:

- No abrir acceso público a Firestore.
- No permitir lectura/escritura global sin auth.
- No permitir que usuarios accedan a datos de otras familias.
- No mover lógica sensible únicamente a Flutter.
- No confiar en datos enviados por el cliente para permisos.
- Las reglas deben evolucionar hacia validación por pertenencia a familia.
- El acceso debe estar alineado con `familyId`.
- Cualquier cambio en reglas debe revisarse antes de commit.

Pendientes relacionados:

- `D-008-reglas-firestore`
- `D-012-flujo-familia-post-auth`
- `D-013-persistencia-coherente-de-familias-reales`

---

## Familias

Situación heredada del MVP:

- Puede existir `familyId = uid`.
- No siempre existe documento real en `families`.

Objetivo post-TFG:

- Toda familia debe existir como documento real en Firestore.
- `familyId` debe apuntar a una familia válida.
- La pertenencia debe poder comprobarse.
- Las reglas de seguridad deben poder apoyarse en esa pertenencia.

No hacer sin autorización:

- Implementar colaboración real sin revisar modelo de familia.
- Implementar invitaciones sin definir seguridad.
- Mezclar nuevas features con familias implícitas sin documentarlo.

---

## Recetas

Estado actual:

- Crear receta.
- Consultar recetas.
- Modificar receta.
- Eliminar receta.

Pendiente relevante:

- Integración real de imágenes con Firebase Storage.

Reglas:

- No usar Storage desde UI.
- No guardar rutas inconsistentes.
- No subir imágenes sin path claro.
- No dejar archivos huérfanos al eliminar receta.
- No implementar caché/lazy loading avanzado antes de tener integración básica.
- No cambiar modelo de `Recipe` sin autorización.

Pendientes relacionados:

- `D-014-integracion-imagenes-storage`
- `D-015-configuracion-storage-y-entornos`
- `D-016-gestion-imagenes`

---

## Weekly Plan

Estado actual:

- Planificación semanal funcional con Firestore.

Limitación conocida:

- Una planificación semanal activa por familia.

No hacer todavía sin autorización:

- Soporte multisemana.
- Histórico.
- Estadísticas.
- Navegación temporal avanzada.

Pendientes relacionados:

- `D-003-multiples-semanas-planificacion`
- `D-002-redundancia-mealtype`

---

## Flujo de trabajo

Trabajar siempre por checkpoints:

1. Inspección si falta contexto.
2. Cambio mínimo.
3. Validación.
4. Revisión.
5. Commit.

No implementar varios bloques a la vez.

Un checkpoint debe tener:

- Objetivo concreto.
- Archivos afectados.
- Límites claros.
- Criterio de validación.
- Resultado revisable.

---

## Formato esperado para tareas de implementación

Cuando se pida código:

- Tocar solo archivos indicados.
- No explicar de más.
- No añadir cambios no pedidos.
- No introducir dependencias nuevas.
- No hacer refactors implícitos.
- Devolver cambios por archivo.
- Terminar con `STOP` si el prompt lo pide.

Formato típico:

```text
Objetivo:
[describir objetivo concreto]

Archivos a modificar:
- [archivo 1]
- [archivo 2]

No tocar:
- [archivo o capa que no debe cambiarse]

Criterios de validación:
- [criterio 1]
- [criterio 2]

Formato:
- Cambios por archivo.
- Sin explicaciones largas.
- Sin cambios adicionales.

STOP
```

---

## Uso recomendado de agentes

### Claude Code / Claude en VS Code

Implementador principal.

Debe:

- Ejecutar checkpoints concretos.
- Respetar archivos indicados.
- Respetar `claude.md`.
- No hacer refactors no solicitados.
- No modificar fuera de scope.
- No decidir arquitectura por su cuenta.

Claude implementa, pero no dirige el proyecto.

---

### Codex

Revisor / diagnosticador.

Debe:

- Revisar working tree.
- Detectar bugs.
- Detectar cambios fuera de scope.
- Detectar riesgos de arquitectura.
- Detectar riesgos de seguridad.
- Recomendar aprobar/corregir.
- No modificar código si se le pide revisar.

Codex se usa especialmente antes de commits sensibles.

---

### ChatGPT

Arquitecto y coordinador.

Uso:

- Analizar contexto.
- Diseñar estrategia.
- Priorizar deuda técnica.
- Generar prompts para Claude/Codex.
- Revisar respuestas.
- Decidir siguiente checkpoint.
- Explicar cambios para entenderlos antes de integrar.

ChatGPT piensa y valida; Claude implementa; Codex revisa.

---

## Prompt base para Claude como implementador

```text
Actúa como implementador Flutter/Firebase en el proyecto MenuFlow.

Respeta `AGENTS.md` y `claude.md`.

Objetivo:
[objetivo concreto]

Archivos a modificar:
- [archivo 1]
- [archivo 2]

Puedes:
- [acciones permitidas]

No puedes:
- Cambiar arquitectura.
- Introducir dependencias nuevas.
- Tocar archivos no indicados.
- Hacer refactors globales.
- Modificar comportamiento no relacionado.
- Usar Firebase fuera de `data`.

Criterios de validación:
- El código compila.
- Se respeta el flujo UI → Provider → UseCase → Repository → DataSource → Firebase.
- No hay cambios fuera de scope.

Formato:
- Devuelve solo los cambios necesarios.
- Indica archivo y código modificado.
- Sin explicaciones largas.

STOP
```

---

## Prompt base para Codex como revisor

```text
Actúa como Senior Code Reviewer en el proyecto MenuFlow.

Revisa el working tree actual.

NO modifiques código.

Objetivo:
- Detectar bugs.
- Detectar cambios fuera de scope.
- Detectar riesgos de arquitectura.
- Comprobar imports/dependencias innecesarias.
- Comprobar riesgos de seguridad.
- Comprobar si se rompe Android/iOS/web.
- Comprobar si se respeta feature-first + Clean Architecture simplificada.

Debes revisar especialmente:
- Uso correcto de capas.
- Ausencia de Firebase fuera de `data`.
- Providers y estado Riverpod.
- Modelos y entidades.
- Reglas de Firestore/Storage si han cambiado.
- Cambios no solicitados.

Formato:
## Resumen
## Archivos revisados
## Problemas bloqueantes
## Problemas menores
## Riesgos de arquitectura
## Riesgos de seguridad
## Recomendación
- Aprobar / corregir / revisar manualmente

STOP
```

---

## Prompt base para Codex como diagnosticador

```text
Actúa como Senior Debugging Engineer en el proyecto MenuFlow.

Tenemos un bug concreto.

NO modifiques código todavía.

Objetivo:
Diagnosticar causa probable revisando código real.

Debes seguir el flujo:

UI → Provider → UseCase → Repository → DataSource → Firebase

Comprueba:

- Navegación.
- Estado Riverpod.
- Llamadas a use cases.
- Repositorios.
- Datasources.
- Parsing de modelos.
- Errores silenciados.
- Cambios fuera de scope.
- Reglas de Firebase si aplica.

Formato:

1. Causa probable.
2. Archivos implicados.
3. Evidencia en código.
4. Cambio mínimo recomendado.
5. Riesgos.
6. Si debe implementarlo Claude o corregirse manualmente.

STOP
```

---

## Anti-patrones prohibidos

- Cambios masivos.
- Refactors no solicitados.
- Estado local para datos persistentes.
- Duplicar lógica.
- Saltarse capas.
- Usar Firebase en widgets.
- Usar Firebase en providers.
- Inventar colecciones.
- Inventar campos.
- Ocultar errores de datos.
- Dejar debug temporal.
- Cambiar seguridad sin autorización.
- Mezclar seguridad, UI y modelo de datos en un único checkpoint.
- Mezclar evolución post-TFG con correcciones sobre `main`.

---

## Validación antes de commit

Antes de cualquier commit:

```bash
git status
git diff
```

Si aplica:

```bash
flutter analyze
flutter test
```

Comprobar:

- Archivos tocados.
- Cambios fuera de scope.
- Imports innecesarios.
- Errores de análisis.
- Funcionamiento manual de la feature afectada.
- Reglas de Firebase si se han modificado.

Separar commits por tipo:

- `docs:`
- `feat:`
- `fix:`
- `refactor:`
- `rules:`
- `chore:`

Ejemplos:

```bash
git commit -m "docs: add agents workflow for MenuFlow"
git commit -m "rules: restrict Firestore access to authenticated users"
git commit -m "feat: add basic recipe image upload"
git commit -m "fix: prevent duplicate weekly plan creation"
```

---

## Ramas

Ramas recomendadas:

- `main`
  - Versión estable.
  - Versión entregada/defendible.
  - No usar para evolución directa.

- `post-tfg/dev`
  - Rama principal de evolución post-TFG.

- `feature/nombre-feature`
  - Ramas pequeñas desde `post-tfg/dev` si el cambio lo justifica.

Reglas:

- No commitear evolución post-TFG directamente en `main`.
- No mezclar varias features en una rama.
- No hacer merge sin revisar.
- Usar commits claros y pequeños.

---

## Filosofía

No romper lo que ya funciona.

Seguridad antes que comodidad.

Cambios pequeños, controlados y verificables.

La IA acelera, pero no sustituye el criterio técnico.

MenuFlow debe evolucionar como producto real, no como experimento desordenado.

Si una tarea parece grande, se divide.

Si una IA propone tocar demasiados archivos, se revisa.

Si un cambio no se entiende, no se integra.

Si afecta a seguridad, datos o arquitectura, se revisa antes de commitear.
