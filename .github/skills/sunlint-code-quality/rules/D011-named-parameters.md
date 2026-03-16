---
title: Prefer Named Parameters
impact: LOW
impactDescription: Improve code readability and prevent parameter confusion
tags: readability, safety, clean-code
---

## Prefer Named Parameters

Functions, methods, and constructors with more than 3 parameters that have 2 or more adjacent parameters of the same type should use named parameters. This improves code clarity by making it explicit which value corresponds to which parameter, reducing the risk of accidentally swapping arguments of the same type.

**Incorrect (confusing positional parameters):**

```dart
// At call site, hard to tell which is width and which is height
final rect = Rectangle(100.0, 50.0, 10.0, "red");
```

**Correct (clear named parameters):**

```dart
// Much clearer at call site
final rect = Rectangle(
  width: 100.0,
  height: 50.0,
  padding: 10.0,
  color: "red",
);
```

**Tools:** Custom analyzer (D011)
