---
title: Avoid Single Child in Multi-Child Widget
impact: LOW
impactDescription: Use appropriate widget types for the number of children
tags: performance, efficiency, best-practices
---

## Avoid Single Child in Multi-Child Widget

Multi-child widgets like `Column`, `Row`, `Stack`, `ListView`, or `GridView` are inefficient when used with only a single child. Use single-child optimized widgets like `SizedBox`, `Padding`, `Center`, or `Container` instead.

**Incorrect (inefficient Column):**

```dart
Column(
  children: [
    Text("Only one child here"),
  ],
)
```

**Correct (efficient wrapper):**

```dart
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text("Only one child here"),
)
```

**Tools:** Custom analyzer (D019)
