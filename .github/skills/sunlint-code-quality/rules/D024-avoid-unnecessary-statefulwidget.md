---
title: Avoid Unnecessary StatefulWidget
impact: LOW
impactDescription: Use StatelessWidget when no state management is needed to improve performance
tags: performance, flutter, widgets, best-practices
---

## Avoid Unnecessary StatefulWidget

StatefulWidget should only be used when the widget needs to maintain mutable state that changes over time. If a widget extends StatefulWidget but its State class has no mutable fields, never calls setState(), and doesn't use lifecycle methods beyond build(), it should be converted to StatelessWidget. StatelessWidget is more efficient as it doesn't maintain state and has less overhead.

**Incorrect (StatefulWidget with no state):**

```dart
class MyTitle extends StatefulWidget {
  final String text;
  const MyTitle({super.key, required this.text});

  @override
  State<MyTitle> createState() => _MyTitleState();
}

class _MyTitleState extends State<MyTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}
```

**Correct (StatelessWidget):**

```dart
class MyTitle extends StatelessWidget {
  final String text;
  const MyTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
```

**Tools:** Custom analyzer (D024)
