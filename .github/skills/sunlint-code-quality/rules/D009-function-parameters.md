---
title: Limit Function Parameters
impact: MEDIUM
impactDescription: Improve code readability by limiting the number of function parameters
tags: readability, maintainability, clean-code
---

## Limit Function Parameters

Functions, methods, and constructors should not have more than 5 parameters. Too many parameters make code harder to read, understand, and maintain. When a function needs many parameters, consider grouping related parameters into a data class or using a configuration object.

**Incorrect (too many positional parameters):**

```dart
void createUser(String firstName, String lastName, int age, String email, String phone, String address, String city) {
  // ...
}
```

**Correct (using data object or named parameters):**

```dart
// Option 1: Data class
void createUser(UserDetail details) {
  // ...
}

// Option 2: Grouped named parameters
void createUser({
  required String name,
  required ContactInfo contact,
  required Address address,
}) {
  // ...
}
```

**Tools:** Custom analyzer (D009)
