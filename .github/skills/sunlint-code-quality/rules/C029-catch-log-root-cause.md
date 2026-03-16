---
title: All Catch Blocks Must Log Root Cause
impact: HIGH
impactDescription: enables debugging and incident response
tags: error-handling, logging, debugging, observability, quality
---

## All Catch Blocks Must Log Root Cause

Silent failures make debugging impossible. Without proper logging, you cannot trace issues in production.

**Incorrect (silent or minimal logging):**

```dart
try {
  await processPayment(order);
} catch (e) {
  // Empty catch - silent failure!
}

try {
  await saveUser(user);
} catch (e) {
  return null; // No logging, no context
}
```

**Correct (comprehensive error logging):**

```dart
try {
  await processPayment(order);
} catch (e, st) {
  logger.e(
    'Payment processing failed',
    error: e,
    stackTrace: st,
  );
  logger.e('Context: orderId=${order.id}, userId=${order.userId}, amount=${order.amount}');
  throw PaymentFailedException(
    'Payment could not be processed',
    cause: e,
  );
}
```

**Log context should include:**
- Error object and stack trace (`error:`, `stackTrace:`)
- Relevant entity IDs (order, user, etc.)
- Input that caused the error
- Timing information

**Tools:** logger package, Code Review
