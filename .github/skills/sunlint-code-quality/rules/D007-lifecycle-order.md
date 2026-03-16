---
title: Prefer Init First, Dispose Last
impact: MEDIUM
impactDescription: Ensure proper lifecycle method ordering in StatefulWidget
tags: lifecycle, maintenance, flutter, statefulwidget
---

## Prefer Init First, Dispose Last

In StatefulWidget lifecycle methods, `super.initState()` should be called first before any initialization code, and `super.dispose()` should be called last after all cleanup code. This ensures that the framework's internal state management is properly initialized before your code runs and is the last to clean up.

**Incorrect (wrong order):**

```dart
@override
void initState() {
  _controller = TextEditingController();
  super.initState(); // Called after custom logic
}

@override
void dispose() {
  super.dispose(); // Called before cleanup
  _controller.dispose();
}
```

**Correct (framework-friendly order):**

```dart
@override
void initState() {
  super.initState(); // Always first
  _controller = TextEditingController();
}

@override
void dispose() {
  _controller.dispose();
  super.dispose(); // Always last
}
```

**Tools:** Custom analyzer (D007)
