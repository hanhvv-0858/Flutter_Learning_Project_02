import 'package:dartz/dartz.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';

/// Abstract contract for onboarding persistence operations.
/// Implemented by [OnboardingRepositoryImpl] in the data layer.
abstract class OnboardingRepository {
  Future<Either<Failure, bool>> checkOnboardingStatus();
  Future<Either<Failure, Unit>> completeOnboarding();
}
