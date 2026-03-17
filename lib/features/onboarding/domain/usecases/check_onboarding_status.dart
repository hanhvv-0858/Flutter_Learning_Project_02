import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Returns whether the user has already completed the onboarding tutorial.
@lazySingleton
class CheckOnboardingStatus extends UseCase<bool, NoParams> {
  CheckOnboardingStatus(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.checkOnboardingStatus();
}
