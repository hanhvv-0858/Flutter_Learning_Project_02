---
title: Remove Commented-Out Code
impact: LOW
impactDescription: Keep codebase clean by removing commented-out code
tags: cleanliness, readability, maintenance
---

## Remove Commented-Out Code

Commented-out code should be removed instead of being left in the source files. Dead code comments create clutter and confusion. If you need to reference old code, rely on version control (Git).

**Incorrect (abandoned code):**

```dart
void calculate() {
  final result = 10 + 5;
  // print("Debug result: $result");
  // if (result > 10) {
  //   doSomething();
  // }
  return result;
}
```

**Correct (clean file):**

```dart
void calculate() {
  final result = 10 + 5;
  return result;
}
```

**Tools:** Custom analyzer (D018)
