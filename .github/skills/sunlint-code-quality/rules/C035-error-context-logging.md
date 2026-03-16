---
title: Log All Relevant Context On Errors
impact: HIGH
impactDescription: enables quick debugging and incident response
tags: error-handling, logging, context, debugging, quality
---

## Log All Relevant Context On Errors

Context-rich logs enable quick debugging. Without proper context, finding root causes is like finding a needle in a haystack.

**Incorrect (minimal context):**

```dart
logger.e('Error occurred');
logger.e(e.toString());
```

**Correct (comprehensive context):**

```dart
final stopwatch = Stopwatch()..start();

try {
  await processOrder(order);
} catch (e, st) {
  logger.e(
    'Failed to process order - '
    'orderId=${order.id}, userId=${user.id}, '
    'itemCount=${order.items.length}, total=${order.total}, '
    'processingTimeMs=${stopwatch.elapsedMilliseconds}',
    error: e,
    stackTrace: st,
  );
  rethrow;
}
```

**Essential context to include:**
- Error object and stack trace (`error:`, `stackTrace:`)
- Entity identifiers (orderId, userId, etc.)
- Input that caused the issue (item count, amounts)
- Timing information (`elapsedMilliseconds`)
- Device/session context where applicable (Flutter)

**Flutter-specific context:**

```dart
try {
  await submitForm(formData);
} catch (e, st) {
  logger.e(
    'Form submission failed - '
    'screen=${ModalRoute.of(context)?.settings.name}, '
    'userId=${authProvider.userId}',
    error: e,
    stackTrace: st,
  );
}
```

**Tools:** logger package, Code Review
