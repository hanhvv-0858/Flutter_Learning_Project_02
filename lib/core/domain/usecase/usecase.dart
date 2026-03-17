import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';

/// Base class for all use cases in the domain layer.
///
/// 📚 CLEAN ARCHITECTURE — USE CASE PATTERN
/// A use case represents a single business action the app can perform.
/// It lives in the domain layer and depends ONLY on abstract repositories
/// (dependency inversion principle). This keeps business logic testable
/// and framework-independent.
///
/// Every use case returns `Future<Either<Failure, Type>>` to express
/// success/failure without throwing exceptions across layer boundaries.
/// The `Either` type from dartz forces callers to explicitly handle
/// both success (Right) and failure (Left) paths.
///
/// [T] — the success return type.
/// [Params] — input parameters (use [NoParams] when none needed).
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Placeholder for use cases that require no input parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
