---
title: Project should have tests
impact: HIGH
impactDescription: Ensure code quality and prevent regressions through automated testing
tags: testing, quality, reliability
---

## Project should have tests

Every Dart/Flutter project should have a `test` directory containing test files (files ending with `_test.dart`). Tests are essential for maintaining code quality, catching bugs early, and enabling safe refactoring.

**Incorrect (no tests):**

```text
my_project/
  lib/
  pubspec.yaml
  # MISSING test/ directory
```

**Correct (testing infrastructure included):**

```text
my_project/
  lib/
  test/
    unit_test.dart
    widget_test.dart
  pubspec.yaml
```

**Tools:** Custom analyzer (D016)
