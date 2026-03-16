---
title: Do Not Ignore Superclass Logic
impact: HIGH
impactDescription: ensures proper inheritance behavior
tags: inheritance, override, superclass, oop, quality
---

## Do Not Ignore Superclass Logic

When overriding methods, ensure superclass behavior is preserved unless explicitly intended otherwise. This is especially important in Flutter for `initState`, `dispose`, `build`, and lifecycle methods.

**Incorrect (ignoring superclass):**

```dart
class BaseRepository {
  Future<void> save(Entity entity) async {
    validate(entity);
    await beforeSave(entity);
    await database.insert(entity.toMap());
    await afterSave(entity);
  }
}

class UserRepository extends BaseRepository {
  @override
  Future<void> save(User user) async {
    // Completely ignores validation, hooks, etc.
    await database.insert(user.toMap());
  }
}
```

**Correct (calling super):**

```dart
class UserRepository extends BaseRepository {
  @override
  Future<void> save(User user) async {
    // Add user-specific preprocessing
    user = user.copyWith(updatedAt: DateTime.now());

    // Call superclass implementation
    await super.save(user);

    // Add user-specific postprocessing
    await updateSearchIndex(user);
  }
}
```

**Flutter lifecycle - always call super at correct position:**

```dart
// initState: super FIRST
@override
void initState() {
  super.initState(); // Must be first
  _controller = AnimationController(vsync: this);
}

// dispose: super LAST
@override
void dispose() {
  _controller.dispose(); // Clean up first
  super.dispose(); // Must be last
}

// didChangeDependencies: super FIRST
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _theme = Theme.of(context);
}
```

**When to intentionally skip super:**

```dart
class UserRepository extends BaseRepository {
  /// Override: users require special serialization,
  /// base validation is not applicable for legacy schema.
  @override
  Future<void> save(User user) async {
    await validateUser(user); // Custom validation replaces base
    // Intentionally not calling super.save()
    await userTable.upsert(user.toLegacyMap());
  }
}
```

**Tools:** dart_analyzer, Code Review, flutter_lints
