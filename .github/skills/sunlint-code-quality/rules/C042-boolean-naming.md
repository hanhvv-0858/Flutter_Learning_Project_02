---
title: Boolean Names Is/Has/Should
impact: HIGH
impactDescription: makes conditions instantly readable
tags: naming, booleans, readability, quality
---

## Boolean Names Is/Has/Should

Boolean variable prefixes make conditions instantly readable.

**Incorrect (unclear boolean variable names):**

```dart
final active = user.status == 'active';
final admin = checkAdminRole(user);
final items = cart.isNotEmpty;
final update = needsRefresh();
```

**Correct (boolean prefixes for variables):**

```dart
final isActive = user.status == 'active';
final isAdmin = checkAdminRole(user);
final hasItems = cart.isNotEmpty;
final shouldUpdate = needsRefresh();
final canEdit = hasPermission(user, 'edit');
final willExpire = expirationDate.isBefore(tomorrow);
```

**Boolean prefixes:**

| Prefix | Use For |
|--------|---------|
| `is` | State (isActive, isEnabled, isLoading) |
| `has` | Ownership (hasPermission, hasError, hasItems) |
| `should` | Decision (shouldUpdate, shouldRetry) |
| `can` | Capability (canEdit, canDelete, canSubmit) |
| `will` | Future (willExpire, willRetry) |

**In Flutter widgets:**

```dart
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.isSelected,
    required this.canCancel,
    required this.onTap,
  });

  final Order order;
  final bool isSelected;
  final bool canCancel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue[100] : Colors.white,
      child: ListTile(
        title: Text(order.id),
        trailing: canCancel ? CancelButton(order: order) : null,
        onTap: onTap,
      ),
    );
  }
}
```

**Tools:** Code Review, dart_analyzer
