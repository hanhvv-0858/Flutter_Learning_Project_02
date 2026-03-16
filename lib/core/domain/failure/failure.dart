import 'package:equatable/equatable.dart';

/// Domain-level failure types used across all use cases and repositories.
/// Each failure carries a human-readable [message] for logging/debugging.
sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Remote server returned an error response (4xx, 5xx).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Device has no network connectivity or request timed out.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Local cache (Sqflite / SharedPreferences) read/write failed.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Catch-all for unexpected errors that don't fit other categories.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
