---
title: Do Not Throw Generic Errors
impact: HIGH
impactDescription: enables proper error handling and monitoring
tags: error-handling, exceptions, custom-errors, debugging, quality
---

## Do Not Throw Generic Errors

Generic errors lack context needed for debugging. They make it impossible to distinguish between error types for proper handling.

**Incorrect (generic errors):**

```dart
if (user == null) {
  throw Exception('error');
}

if (!isValid) {
  throw Exception();
}

if (response.statusCode != 200) {
  throw Exception('Failed');
}
```

**Correct (specific custom exceptions):**

```dart
if (user == null) {
  throw UserNotFoundException('User with ID $userId not found');
}

if (!isValid) {
  throw ValidationException(
    field: 'email',
    message: 'Email format is invalid',
    value: email,
  );
}

if (response.statusCode != 200) {
  throw ApiException(
    statusCode: response.statusCode,
    message: 'API request failed',
    endpoint: '/users/$userId',
  );
}
```

Custom exceptions should include:
- Descriptive message with context
- Relevant data for debugging
- Error code for programmatic handling

**Tools:** Code Review, dart_analyzer
