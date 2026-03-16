---
title: Use setState Correctly
impact: HIGH
impactDescription: Ensure setState is used correctly in StatefulWidget to avoid performance issues and bugs
tags: performance, best-practices, lifecycle, state-management
---

## Use setState Correctly

Common `setState` anti-patterns include: calling `setState` inside `build()`, nesting `setState` calls, making multiple `setState` calls in the same method, or using async callbacks inside `setState`. These lead to performance issues, unnecessary rebuilds, or hard-to-track UI bugs.

**Incorrect (async inside setState):**

```dart
setState(() async {
  await fetchData(); // WRONG: setState should be synchronous
  _data = "new data";
});
```

**Correct (sync update after async):**

```dart
// Fetch data first
final newData = await fetchData();

// Update state synchronously
if (mounted) {
  setState(() {
    _data = newData;
  });
}
```

**Tools:** Custom analyzer (D022)
