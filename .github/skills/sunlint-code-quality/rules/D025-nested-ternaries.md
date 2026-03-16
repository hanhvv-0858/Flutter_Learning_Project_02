---
title: Avoid Nested Conditional Expressions
impact: LOW
impactDescription: Improve code readability by avoiding nested ternary operators
tags: readability, maintainability, clean-code
---

## Avoid Nested Conditional Expressions

Nested conditional expressions (ternary operators like `a ? b : c ? d : e`) reduce code readability significantly. When logic is complex, use if-else statements or extract the logic into a well-named variable or function.

**Incorrect (hard to follow):**

```dart
final color = isAdmin ? Colors.red : isLogged ? Colors.green : Colors.grey;
```

**Correct (descriptive logic):**

```dart
// Option 1: if-else
Color userColor;
if (isAdmin) {
  userColor = Colors.red;
} else if (isLogged) {
  userColor = Colors.green;
} else {
  userColor = Colors.grey;
}

// Option 2: Extracted getter
Color get userColor => _calculateUserColor();
```

**Tools:** Custom analyzer (D025)
