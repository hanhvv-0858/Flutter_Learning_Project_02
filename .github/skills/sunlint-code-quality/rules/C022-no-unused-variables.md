---
title: Do Not Leave Unused Variables
impact: LOW
impactDescription: reduces code noise and potential bugs
tags: variables, cleanup, quality
---

## Do Not Leave Unused Variables

Unused variables suggest incomplete refactoring or bugs.

**Incorrect (unused variables):**

```dart
void processOrder(Order order) {
  final user = order.user;   // Never used
  final total = order.total; // Never used
  final items = order.items;

  return items.map((i) => i.name).toList();
}
```

**Correct (only needed variables):**

```dart
void processOrder(Order order) {
  return order.items.map((i) => i.name).toList();
}

// If destructuring/pattern matching, prefix with _ for intentionally ignored
void handleEvent(Map<String, dynamic> event) {
  final type = event['type'] as String;
  final _ = event['payload']; // Intentionally ignored
  print('Event: $type');
}
```

**Enable via analysis_options.yaml:**

```yaml
# analysis_options.yaml
linter:
  rules:
    - unused_local_variable
    - unused_element
    - avoid_unused_constructor_parameters
```

**Tools:** dart analyze, `unused_local_variable` lint rule
