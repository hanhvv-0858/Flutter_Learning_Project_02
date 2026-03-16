---
title: Avoid Negated Boolean Checks
impact: LOW
impactDescription: Improve code readability by avoiding inverted or negated boolean conditions
tags: readability, logic, clean-code
---

## Avoid Negated Boolean Checks

Negated boolean checks (using `!`) make code harder to read and understand. Replace negative conditions with positive ones wherever possible, and avoid double negations like `!!`.

**Incorrect (fragmented logic):**

```dart
if (!isNotAuthorized) { ... }
if (!(a == b)) { ... }
```

**Correct (clear logic):**

```dart
if (isAuthorized) { ... }
if (a != b) { ... }
```

**Tools:** Custom analyzer (D021)
