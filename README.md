# MenuFlow

MenuFlow es una aplicación móvil multiplataforma desarrollada con Flutter y Firebase cuyo objetivo es facilitar la gestión colaborativa de menús semanales en entornos familiares o de convivencia.

---

## 📌 Descripción

La aplicación permite a varios usuarios organizar conjuntamente las comidas de la semana, compartir recetas y participar en la planificación del menú mediante un sistema de propuestas y validaciones.

El sistema introduce un modelo basado en roles, donde un administrador de familia supervisa y valida los cambios, garantizando coherencia en la planificación.

---

## 🎯 Objetivo del proyecto

Este proyecto se desarrolla como Trabajo Fin de Grado (TFG) del ciclo formativo de Desarrollo de Aplicaciones Multiplataforma (DAM).

El objetivo principal es diseñar e implementar un MVP funcional que:

- resuelva un problema real de organización doméstica
- aplique buenas prácticas de arquitectura de software
- sea escalable y mantenible a medio y largo plazo

---

## ⚙️ Funcionalidades principales

- Registro e inicio de sesión de usuarios
- Creación y gestión de familias
- Unión a familias mediante código de invitación
- Gestión de recetas compartidas
- Planificación semanal de menús (comidas y cenas)
- Propuestas de cambio sobre el menú
- Validación de propuestas por parte del administrador

---

## 🧱 Arquitectura del sistema

La aplicación sigue una arquitectura por capas con separación de responsabilidades:

- **Presentación** → interfaz de usuario (Flutter)
- **Lógica de negocio** → reglas del sistema
- **Acceso a datos** → integración con Firebase

Este enfoque permite:

- mejorar la mantenibilidad
- facilitar la escalabilidad
- aislar dependencias externas

---

## 🛠 Tecnologías utilizadas

- **Flutter** (UI multiplataforma)
- **Dart**
- **Firebase Authentication** (gestión de usuarios)
- **Cloud Firestore** (base de datos NoSQL)
- **Firebase Storage** (almacenamiento de imágenes)

---

## 📊 Modelo funcional (resumen)

El sistema se basa en las siguientes entidades principales:

- User
- Family
- FamilyMember
- Recipe
- WeeklyPlan
- PlannedMeal
- PlanChangeProposal

Relaciones clave:

- Un usuario puede pertenecer a varias familias
- Una familia gestiona recetas y planificaciones semanales
- Las comidas planificadas se basan en recetas
- Los cambios en el menú requieren validación

---

## 🚧 Estado actual del proyecto

El proyecto se encuentra actualmente en fase de:

- análisis del sistema
- diseño de arquitectura
- definición del modelo de datos
- preparación del entorno de desarrollo

En paralelo, se está desarrollando la memoria del TFG.

---

## 🔮 Líneas futuras de evolución

El diseño del sistema permite la incorporación de nuevas funcionalidades, como:

- listas de compra compartidas
- intercambio de recetas entre familias
- estadísticas de consumo
- recomendaciones de recetas
- notificaciones inteligentes

---

## 👨‍💻 Autor

Proyecto desarrollado como TFG del ciclo DAM.