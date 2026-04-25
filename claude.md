# MenuFlow — Claude Context (claude.md)

## 🧠 Project Overview

MenuFlow is a Flutter mobile application built with Firebase (Auth, Firestore, Storage) that allows families to collaboratively manage weekly meal planning.

The project is in **post-MVP (post-TFG) phase**, evolving towards a real product with scalability and monetization in mind.

---

## 🏗️ Architecture

The project follows a **feature-first structure** with a simplified Clean Architecture approach.

### Layers

* `presentation` → UI, widgets, providers (Riverpod)
* `domain` → entities, repositories (abstract), use cases
* `data` → models, repository implementations, datasources (Firebase)

### Dependency Rules

* `presentation` → depends on `domain`
* `data` → depends on `domain`
* `domain` → **must not depend on any external layer or framework**

---

## 🔁 Data Flow

UI → Provider → UseCase → Repository → DataSource → Firebase

This flow must always be respected.

---

## ⚠️ Strict Rules

### Architecture

* ❌ Do NOT use Firebase directly outside `data`
* ❌ Do NOT place business logic in UI (`presentation`)
* ❌ Do NOT bypass use cases
* ❌ Do NOT mix models and entities

### Domain

* Entities must be:

  * immutable
  * framework-independent
* No Firebase, JSON, or external dependencies allowed

### Data Layer

* Models handle:

  * serialization / deserialization
  * mapping to/from entities
* Datasources interact with Firebase only

---

## 🧩 Development Guidelines

* Prioritize **minimal, incremental changes**
* Avoid large refactors unless explicitly requested
* Maintain existing architecture and patterns
* Prefer clarity over cleverness
* Do not introduce new dependencies unless justified

---

## 🔐 Firebase Guidelines

* Firestore is the primary database
* Data must be structured by `familyId`
* Security rules will be enforced (do not assume open access)

---

## 🧪 Code Generation Rules

When generating code:

* Respect existing folder structure and naming conventions
* Only modify what is necessary
* Do not rewrite unrelated files
* Provide code ready to integrate
* Avoid placeholders or pseudo-code

---

## 🧠 Context Awareness

* This is a real product, not just an academic project
* Technical debt should be minimized, but not at the cost of blocking progress
* Some improvements are intentionally postponed (documented as D-XXX)

---

## 🚫 Anti-Patterns to Avoid

* Overengineering
* Global refactors
* Mixing responsibilities across layers
* Adding logic “just in case”
* Ignoring existing architecture

---

## ✅ Expected Output Style

* Clear, minimal, and production-ready code
* Consistent with current architecture
* Easy to understand and integrate

---

## 📌 Important

If the task is unclear or too broad:

→ Ask for clarification instead of making assumptions.
