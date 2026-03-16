import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:example_flutter_02/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Concrete implementation of [OnboardingRepository].
/// Maps datasource results to [Either<Failure, T>] for the domain layer.
@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._datasource);

  final OnboardingLocalDatasource _datasource;

  @override
  Future<Either<Failure, bool>> checkOnboardingStatus() async {
    try {
      final isComplete = await _datasource.isOnboardingComplete();
      return Right(isComplete);
    } catch (e, st) {
      // log(
      //   'checkOnboardingStatus failed',
      //   error: e,
      //   stackTrace: st,
      //   name: 'OnboardingRepositoryImpl',
      // );
      // Nếu có userId/requestId, thêm vào message/context
      return const Left(CacheFailure('Failed to read onboarding status'));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    try {
      await _datasource.completeOnboarding();
      return const Right(unit);
    } catch (e, st) {
      log(
        'completeOnboarding failed',
        error: e,
        stackTrace: st,
        name: 'OnboardingRepositoryImpl',
      );
      return const Left(CacheFailure('Failed to save onboarding status'));
    }
  }
}
