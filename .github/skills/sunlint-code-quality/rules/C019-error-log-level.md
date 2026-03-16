---
title: Do Not Use Error Log For Non-critical
impact: HIGH
impactDescription: prevents alert fatigue and log noise
tags: logging, log-levels, error, observability, quality
---

## Do Not Use Error Log For Non-critical

Incorrect log levels cause alert fatigue and hide real issues. When everything is an "error", nothing is.

**Incorrect (overusing error level):**

```dart
// NOT an error - expected business case
logger.e('User entered wrong password');

// NOT an error - validation failure
logger.e('Email format invalid');

// NOT an error - retry in progress
logger.e('Retry attempt 2 of 5');
```

**Correct (appropriate log levels):**

```dart
// WARN - recoverable, may need attention
logger.w('Payment retry attempt', error: {'attempt': 2, 'maxAttempts': 5});

// INFO - normal business events  
logger.i('Login failed - invalid password', {'userId': userId, 'attempts': 3});

// DEBUG - detailed troubleshooting
logger.d('Validation failed', error: {'field': 'email'});

// ERROR - only for actual system / unrecoverable failures
logger.e('Database connection lost', error: e, stackTrace: st);
```

**Log Level Guide (using `logger` package):**

| Method | Level | Use For |
|--------|-------|---------|
| `logger.e()` | ERROR | System failures, crashes, unrecoverable |
| `logger.w()` | WARN | Potential issues, degraded performance |
| `logger.i()` | INFO | Business events, state changes |
| `logger.d()` | DEBUG | Detailed troubleshooting |

**Tools:** logger package, Code Review
