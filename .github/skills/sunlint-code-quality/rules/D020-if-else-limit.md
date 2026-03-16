---
title: Limit If/Else Branches
impact: LOW
impactDescription: Reduce complexity by limiting the number of if/else branches
tags: readability, complexity, clean-code
---

## Limit If/Else Branches

Complex if/else chains with more than 3 branches reduce code readability and increase cyclomatic complexity. When facing multiple branches, consider using `switch` statements, lookup tables (Maps), or the Strategy pattern.

**Incorrect (long if/else chain):**

```dart
if (type == 'A') {
  doA();
} else if (type == 'B') {
  doB();
} else if (type == 'C') {
  doC();
} else if (type == 'D') {
  doD();
} else {
  doDefault();
}
```

**Correct (using switch or Map):**

```dart
// Option 1: Switch (better readability)
switch (type) {
  case 'A': doA(); break;
  case 'B': doB(); break;
  case 'C': doC(); break;
  case 'D': doD(); break;
  default: doDefault();
}
```

**Tools:** Custom analyzer (D020)
