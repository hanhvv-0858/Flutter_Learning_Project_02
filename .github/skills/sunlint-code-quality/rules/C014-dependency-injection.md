---
title: Use Dependency Injection
impact: HIGH
impactDescription: enables testability and loose coupling
tags: dependency-injection, testing, coupling, architecture, quality
---

## Use Dependency Injection

Direct instantiation creates tight coupling, making testing difficult and changes risky. DI enables mockability, replaceability, and testability.

**Incorrect (hardcoded dependencies):**

```dart
class OrderService {
  final _db = DatabaseHelper(); // Hardcoded dependency
  final _mailer = EmailService(); // Hardcoded dependency

  Future<Order> createOrder(OrderData data) async {
    final order = await _db.insert('orders', data.toMap());
    await _mailer.send(data.email, 'Order created');
    return order;
  }
}
```

**Correct (injected dependencies):**

```dart
abstract class IDatabase {
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data);
}

abstract class IMailer {
  Future<void> send(String to, String message);
}

class OrderService {
  OrderService({
    required IDatabase db,
    required IMailer mailer,
  }) : _db = db,
       _mailer = mailer;

  final IDatabase _db;
  final IMailer _mailer;

  Future<Order> createOrder(OrderData data) async {
    final order = await _db.insert('orders', data.toMap());
    await _mailer.send(data.email, 'Order created');
    return order;
  }
}

// Usage - production
final service = OrderService(
  db: SqliteDatabase(path: dbPath),
  mailer: SmtpMailer(host: smtpHost),
);

// Usage - testing
final service = OrderService(
  db: MockDatabase(),
  mailer: MockMailer(),
);
```

**With get_it or injectable:**

```dart
// Using get_it
@injectable
class OrderService {
  OrderService(this._db, this._mailer);

  final IDatabase _db;
  final IMailer _mailer;
}

// Register
GetIt.instance.registerFactory<OrderService>(
  () => OrderService(GetIt.instance(), GetIt.instance()),
);
```

**Benefits:**
- Easy mocking for unit tests
- Swappable implementations
- Clear dependencies visible in constructor
- Supports interface-based design

**Tools:** get_it, injectable, mockito, mocktail
