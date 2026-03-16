---
title: Avoid Unnecessary Method Overrides
impact: LOW
impactDescription: Remove methods that only call super with the same parameters as they add no value
tags: readability, clean-code, refactoring
---

## Avoid Unnecessary Method Overrides

Methods that override a parent method but only call `super.methodName()` with the same parameters are unnecessary and should be removed. These empty overrides add no functionality and create unnecessary code clutter. Common examples include lifecycle methods like `initState()`, `dispose()`, or `didUpdateWidget()` that only call their super implementation.

**Incorrect (super call only):**

```dart
@override
void initState() {
  super.initState();
}

@override
void dispose() {
  super.dispose();
}
```

**Correct (remove if no logic):**

```dart
// Just remove the method override entirely if it only calls super
```

**Tools:** Custom analyzer (D023)
