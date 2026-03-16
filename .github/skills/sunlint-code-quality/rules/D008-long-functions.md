---
title: Avoid Long Functions
impact: MEDIUM
impactDescription: Improve code readability and maintainability by limiting function length
tags: readability, maintainability, clean-code, dev-efficiency
---

## Avoid Long Functions

Functions should not exceed 60 lines of effective code (excluding comments and opening/closing braces). Long functions are harder to understand, test, and maintain. They often indicate that the function is doing too much and should be broken down into smaller, more focused functions.

**Incorrect (too long):**

```dart
void processOrder(Order order) {
  // Line 1
  // ... 60+ more lines of logic ...
  // Line 70
}
```

**Correct (modular functions):**

```dart
void processOrder(Order order) {
  validateOrder(order);
  calculateTotal(order);
  saveToDatabase(order);
  sendNotification(order);
}

void validateOrder(Order order) { ... }
void calculateTotal(Order order) { ... }
// Each function is focused and short
```

**Tools:** Custom analyzer (D008)
