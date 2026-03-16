---
title: Use Custom Exception Classes
impact: HIGH
impactDescription: enables proper error categorization and handling
tags: error-handling, custom-errors, exceptions, patterns, quality
---

## Use Custom Exception Classes

Custom exception classes enable proper error handling, categorization, and monitoring. They provide clear contracts for callers.

**Incorrect (generic exceptions):**

```dart
throw Exception('User not found');
throw Exception('Invalid input');
throw Exception('Network error');
```

**Correct (custom exception hierarchy):**

```dart
// Base application exception
class AppException implements Exception {
  const AppException(this.message, {this.code, this.context});

  final String message;
  final String? code;
  final Map<String, dynamic>? context;

  @override
  String toString() => 'AppException($code): $message';
}

// Specific exceptions
class UserNotFoundException extends AppException {
  UserNotFoundException(String userId)
      : super(
          'User $userId not found',
          code: 'USER_NOT_FOUND',
          context: {'userId': userId},
        );
}

class ValidationException extends AppException {
  ValidationException({required String field, required String message})
      : super(
          message,
          code: 'VALIDATION_ERROR',
          context: {'field': field},
        );
}

class NetworkException extends AppException {
  NetworkException({required int statusCode, required String endpoint})
      : super(
          'Network request failed with status $statusCode',
          code: 'NETWORK_ERROR',
          context: {'statusCode': statusCode, 'endpoint': endpoint},
        );
}

// Usage
throw UserNotFoundException(userId);
throw ValidationException(field: 'email', message: 'Invalid email format');
throw NetworkException(statusCode: response.statusCode, endpoint: '/users');

// Handling
try {
  await fetchUser(id);
} on UserNotFoundException catch (e) {
  showNotFoundScreen();
} on NetworkException catch (e) {
  showNetworkError();
} on AppException catch (e) {
  showGenericError(e.message);
}
```

**Benefits:**
- Type-safe error handling with `on`
- Structured error context
- Consistent error format
- Clear error hierarchy

**Tools:** Code Review, dart_analyzer
