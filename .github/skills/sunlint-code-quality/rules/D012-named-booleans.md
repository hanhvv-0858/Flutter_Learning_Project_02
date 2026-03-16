---
title: Prefer Named Boolean Parameters
impact: LOW
impactDescription: Improve code readability by avoiding unclear boolean parameters
tags: readability, clean-code, boolean
---

## Prefer Named Boolean Parameters

Boolean parameters in functions make code harder to understand at call sites (the "Boolean Trap"). When a function has boolean parameters, use named parameters to make the intent explicit. Better yet, create separate functions (e.g., `enableUser()` instead of `setUser(true)`).

**Incorrect (unclear boolean meaning):**

```dart
updateStatus(user, true); // What does true mean? Is it active? deleted? admin?
```

**Correct (explicit naming):**

```dart
// Option 1: Named parameter
updateStatus(user, isActive: true);

// Option 2: Semantic function
activateUser(user);
```

**Tools:** Custom analyzer (D012)
