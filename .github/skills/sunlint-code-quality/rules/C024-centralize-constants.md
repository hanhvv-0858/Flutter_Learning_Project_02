---
title: Centralize Constants
impact: HIGH
impactDescription: makes values easy to find and update
tags: constants, magic-numbers, configuration, quality
---

## Centralize Constants

Magic numbers scattered throughout code are hard to find and change.

**Incorrect (magic numbers):**

```dart
if (password.length < 8) { }
if (retryCount > 3) { }
if (status == 1) { }
await Future.delayed(const Duration(milliseconds: 300000));
if (user.role == 'admin') { }
```

**Correct (centralized constants):**

```dart
// lib/constants/app_constants.dart
class AppConstants {
  AppConstants._(); // Prevent instantiation

  static const int passwordMinLength = 8;
  static const int maxRetryAttempts = 3;
  static const Duration sessionTimeout = Duration(minutes: 5);
}

class OrderStatus {
  OrderStatus._();

  static const int pending = 1;
  static const int approved = 2;
  static const int shipped = 3;
}

class UserRole {
  UserRole._();

  static const String admin = 'admin';
  static const String user = 'user';
  static const String guest = 'guest';
}

// Usage
if (password.length < AppConstants.passwordMinLength) { }
if (retryCount > AppConstants.maxRetryAttempts) { }
if (status == OrderStatus.pending) { }
await Future.delayed(AppConstants.sessionTimeout);
if (user.role == UserRole.admin) { }
```

**Alternative: use enums for type-safe values:**

```dart
enum OrderStatus { pending, approved, shipped }
enum UserRole { admin, user, guest }

// Usage
if (order.status == OrderStatus.pending) { }
if (user.role == UserRole.admin) { }
```

**Benefits:**
- Single source of truth
- Self-documenting
- Easy to update
- Type safety with enums

**Tools:** dart analyze, Code Review
