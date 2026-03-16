---
title: Always Dispose Resources and Remove Listeners
impact: HIGH
impactDescription: Prevent memory leaks by ensuring proper resource disposal
tags: memory-leak, resources, disposal, lifecycle, performance
---

## Always Dispose Resources and Remove Listeners

All disposable resources (Controllers, StreamSubscriptions, FocusNodes, Listeners) must be properly disposed in the `dispose()` method. This includes TextEditingController, AnimationController, ScrollController, StreamSubscription, FocusNode, and other resources that implement Disposable. Failing to dispose these resources leads to memory leaks.

**Incorrect (not disposed):**

```dart
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

**Correct (properly disposed):**

```dart
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

**Tools:** Custom analyzer (D002)
