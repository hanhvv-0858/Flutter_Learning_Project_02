---
title: Separate Processing And Data Access
impact: HIGH
impactDescription: enables testable business logic
tags: separation, repository, service, architecture, quality
---

## Separate Processing And Data Access

Mixing business logic with database/API access creates tight coupling and makes testing require real databases or network.

**Incorrect (mixed concerns):**

```dart
class OrderService {
  final database = DatabaseHelper.instance;

  Future<double> calculateDiscount(String userId) async {
    // Business logic mixed with data access
    final userMap = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    final orderMaps = await database.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    double discount = 0;
    if (orderMaps.length > 10) discount += 5;
    if (userMap.first['is_premium'] == 1) discount += 10;

    return discount;
  }
}
```

**Correct (separated layers):**

```dart
// Repository - data access only
abstract class IUserRepository {
  Future<User?> findById(String userId);
}

abstract class IOrderRepository {
  Future<List<Order>> findByUserId(String userId);
}

class SqlUserRepository implements IUserRepository {
  SqlUserRepository(this._db);
  final DatabaseHelper _db;

  @override
  Future<User?> findById(String userId) async {
    final maps = await _db.query('users', where: 'id = ?', whereArgs: [userId]);
    return maps.isEmpty ? null : User.fromMap(maps.first);
  }
}

// Service - business logic only
class DiscountService {
  DiscountService({
    required IUserRepository userRepo,
    required IOrderRepository orderRepo,
  }) : _userRepo = userRepo,
       _orderRepo = orderRepo;

  final IUserRepository _userRepo;
  final IOrderRepository _orderRepo;

  Future<double> calculateDiscount(String userId) async {
    final user = await _userRepo.findById(userId);
    final orders = await _orderRepo.findByUserId(userId);

    return _computeDiscount(user, orders);
  }

  double _computeDiscount(User? user, List<Order> orders) {
    double discount = 0;
    if (orders.length > 10) discount += 5;
    if (user?.isPremium == true) discount += 10;
    return discount;
  }
}
```

**Tools:** Code Review, Architecture Review
