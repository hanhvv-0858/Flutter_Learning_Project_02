---
title: No Duplicate Variable Names In Scope
impact: HIGH
impactDescription: prevents shadowing bugs
tags: variables, shadowing, scope, quality
---

## No Duplicate Variable Names In Scope

Variable shadowing causes subtle bugs where inner variables hide outer ones.

**Incorrect (shadowed variables):**

```dart
final user = getCurrentUser();

void processOrder(Order order) {
  final user = order.user; // Shadows outer user!

  // Which user is this?
  print(user.name);
}

// Same name in nested scope
for (final item in items) {
  final item = transform(item); // Shadows loop variable!
}
```

**Correct (unique names):**

```dart
final currentUser = getCurrentUser();

void processOrder(Order order) {
  final orderUser = order.user; // Clear distinction

  print(orderUser.name);
}

// Different names in nested scope
for (final item in items) {
  final transformedItem = transform(item);
}
```

**Enable via analysis_options.yaml:**

```yaml
# analysis_options.yaml
linter:
  rules:
    - no_leading_underscores_for_local_identifiers
```

**Tools:** dart analyze, Code Review
