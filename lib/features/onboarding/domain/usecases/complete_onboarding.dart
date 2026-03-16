import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Marks the onboarding tutorial as completed so it is not shown again.
@lazySingleton
class CompleteOnboarding extends UseCase<Unit, NoParams> {
  CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.completeOnboarding();
}
