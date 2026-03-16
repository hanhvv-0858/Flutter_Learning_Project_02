---
title: Prefer a Single Public Class Per File
impact: LOW
impactDescription: Improve code organization and maintainability
tags: organization, maintainability, clean-code
---

## Prefer a Single Public Class Per File

Each Dart file should contain only one public class. Multiple public classes in a single file make code harder to navigate, test, and maintain. Private implementation classes (starting with `_`) are allowed in the same file.

**Incorrect (multiple public classes):**

```dart
// user_models.dart
class User { ... }
class UserProfile { ... }
class UserSettings { ... }
```

**Correct (split into separate files):**

```dart
// user.dart
class User { ... }

// user_profile.dart
class UserProfile { ... }

// user_settings.dart
class UserSettings { ... }
```

**Tools:** Custom analyzer (D013)
