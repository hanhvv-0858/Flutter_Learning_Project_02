---
title: Avoid Unsafe Collection Access
impact: HIGH
impactDescription: Prevent runtime errors from accessing empty collections
tags: safety, stability, collections, crash-prevention
---

## Avoid Unsafe Collection Access

Using `.first`, `.last`, or `.single` on collections without checking if they're empty causes runtime `StateError` exceptions. Always check `isEmpty`, `isNotEmpty`, or use safe alternatives from `collection` package or built-in `firstOrNull`.

**Incorrect (potential crash):**

```dart
final firstUser = users.first; // Throws StateError if users is empty
```

**Correct (safe access):**

```dart
// Option 1: check length
if (users.isNotEmpty) {
  final firstUser = users.first;
}

// Option 2: use null-safe getter (Dart 3.0+)
final firstUser = users.firstOrNull;
```

**Tools:** Custom analyzer (D014)
