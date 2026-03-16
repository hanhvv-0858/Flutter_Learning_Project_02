---
title: Avoid shrinkWrap in ListView
impact: LOW
impactDescription: Prevent performance issues caused by shrinkWrap in scrollable widgets
tags: performance, scroll, listview, lazy-loading
---

## Avoid shrinkWrap in ListView

Using `shrinkWrap: true` in ListView or GridView disables lazy loading and forces all items to render at once, causing severe performance degradation. Instead, use Expanded or Flexible widgets to constrain the ListView size, or use SliverList within a CustomScrollView for better performance. The shrinkWrap parameter should only be used in rare cases where the list is guaranteed to be small.

**Incorrect (using shrinkWrap):**

```dart
ListView(
  shrinkWrap: true,
  children: [ ... ],
)
```

**Correct (using Expanded):**

```dart
Expanded(
  child: ListView(
    children: [ ... ],
  ),
)
```

**Tools:** Custom analyzer (D004)
