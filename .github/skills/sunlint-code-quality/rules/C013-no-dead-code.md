---
title: Do Not Use Dead Code
impact: LOW
impactDescription: reduces codebase noise and app size
tags: dead-code, cleanup, maintenance, quality
---

## Do Not Use Dead Code

Dead code confuses readers and increases app size. Git history preserves deleted code.

**Incorrect (keeping dead code):**

```dart
void processOrder(Order order) {
  // Old implementation - keeping for reference
  // final total = order.items.fold(0.0, (sum, item) {
  //   return sum + item.price * item.quantity;
  // });

  final total = calculateTotal(order);
  return total;
}

// Unused function - someone might need it later
double legacyCalculation(List<Item> items) {
  return items.length * 10.0;
}

import 'package:app/utils/unused_helper.dart'; // Never used
```

**Correct (clean code):**

```dart
void processOrder(Order order) {
  final total = calculateTotal(order);
  return total;
}

// Delete unused functions - git history preserves them
// Delete commented code - git history preserves it
// Remove unused imports
```

**Types of dead code:**
- Commented-out code blocks
- Unused functions/classes/mixins
- Unused imports
- Unreachable code (after `return`/`throw`)
- Unused variables and parameters

**Tools:** dart analyze, `unused_import` lint rule, Code Review
