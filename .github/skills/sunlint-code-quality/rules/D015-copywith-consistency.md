---
title: Ensure copyWith includes all constructor parameters
impact: MEDIUM
impactDescription: Maintain data integrity and completeness in immutable objects
tags: safety, immutability, data-integrity, boilerplate
---

## Ensure copyWith includes all constructor parameters

When a class implements a `copyWith` method for creating modified copies, it should include all constructor parameters. Missing parameters in `copyWith` can lead to unintended data loss or inability to update certain fields. This is especially important for data classes, models, and immutable state objects.

**Incorrect (incomplete copyWith):**

```dart
class User {
  final String id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});

  User copyWith({String? name}) {
    return User(
      id: this.id,
      name: name ?? this.name,
      age: this.age, // age cannot be updated via copyWith
    );
  }
}
```

**Correct (complete copyWith):**

```dart
class User {
  final String id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});

  User copyWith({String? name, int? age}) {
    return User(
      id: this.id,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
```

**Tools:** Custom analyzer (D015)
