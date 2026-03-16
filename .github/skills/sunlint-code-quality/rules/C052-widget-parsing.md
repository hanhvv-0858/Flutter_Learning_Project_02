---
title: Separate Parsing From Widgets And Controllers
impact: HIGH
impactDescription: keeps widgets/controllers thin and focused
tags: widget, controller, parsing, transformation, patterns, quality
---

## Separate Parsing From Widgets And Controllers

Widgets and controllers should be thin — only handling UI/flow concerns. Data transformation logic should be extracted into mappers or presenters.

**Incorrect (transformation in widget/controller):**

```dart
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    // Transformation logic inside widget
    final fullName = '${user.firstName} ${user.lastName}';
    final email = user.email.toLowerCase();
    final createdAt = DateFormat('yyyy-MM-dd').format(user.createdAt);
    final age = DateTime.now().difference(user.birthDate).inDays ~/ 365;
    final avatarUrl = 'https://cdn.example.com/avatars/${user.id}.jpg';

    return Column(
      children: [
        Text(fullName),
        Text(email),
        Text('Joined: $createdAt'),
        Text('Age: $age'),
        Image.network(avatarUrl),
      ],
    );
  }
}
```

**Correct (separate mapper/presenter):**

```dart
// Presenter / ViewModel
class UserProfilePresenter {
  UserProfilePresenter(this._user);
  final User _user;

  String get fullName => '${_user.firstName} ${_user.lastName}';
  String get email => _user.email.toLowerCase();
  String get joinedDate => DateFormat('yyyy-MM-dd').format(_user.createdAt);
  int get age => DateTime.now().difference(_user.birthDate).inDays ~/ 365;
  String get avatarUrl => 'https://cdn.example.com/avatars/${_user.id}.jpg';
}

// Thin widget
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final presenter = UserProfilePresenter(user);

    return Column(
      children: [
        Text(presenter.fullName),
        Text(presenter.email),
        Text('Joined: ${presenter.joinedDate}'),
        Text('Age: ${presenter.age}'),
        Image.network(presenter.avatarUrl),
      ],
    );
  }
}
```

**Benefits:**
- Reusable transformation logic
- Testable presenters/mappers
- Clean, readable widgets
- Consistent display format

**Tools:** Code Review, Architecture Review
