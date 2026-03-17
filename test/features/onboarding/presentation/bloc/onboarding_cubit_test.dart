import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:flutter_learning_project_2/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:flutter_learning_project_2/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockCompleteOnboarding extends Mock implements CompleteOnboarding {}

void main() {
  late MockCompleteOnboarding mockCompleteOnboarding;

  setUp(() {
    mockCompleteOnboarding = MockCompleteOnboarding();
    // Default: completing onboarding succeeds
    when(
      () => mockCompleteOnboarding(NoParams()),
    ).thenAnswer((_) async => const Right(unit));
  });

  setUpAll(() => registerFallbackValue(NoParams()));

  group('initial state', () {
    test('is OnboardingActive(0)', () {
      final cubit = OnboardingCubit(mockCompleteOnboarding);
      expect(cubit.state, isA<OnboardingActive>());
      expect((cubit.state as OnboardingActive).currentPage, 0);
      cubit.close();
    });
  });

  group('nextPage()', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'increments currentPage when not on last page',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      act: (cubit) => cubit.nextPage(3),
      expect: () => [const OnboardingActive(1)],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'increments from page 1 to page 2',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      seed: () => const OnboardingActive(1),
      act: (cubit) => cubit.nextPage(3),
      expect: () => [const OnboardingActive(2)],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'emits OnboardingComplete when on last page',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      seed: () => const OnboardingActive(2),
      act: (cubit) => cubit.nextPage(3),
      expect: () => [isA<OnboardingComplete>()],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'is no-op when state is OnboardingComplete',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      seed: () => const OnboardingComplete(),
      act: (cubit) => cubit.nextPage(3),
      expect: () => <OnboardingState>[],
    );
  });

  group('skip()', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'emits OnboardingComplete immediately',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      act: (cubit) => cubit.skip(),
      expect: () => [isA<OnboardingComplete>()],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'still emits OnboardingComplete when completeOnboarding fails',
      build: () {
        when(
          () => mockCompleteOnboarding(NoParams()),
        ).thenAnswer((_) async => const Left(CacheFailure('write error')));
        return OnboardingCubit(mockCompleteOnboarding);
      },
      act: (cubit) => cubit.skip(),
      expect: () => [isA<OnboardingComplete>()],
    );
  });

  group('syncPage()', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'emits OnboardingActive with new page when page differs',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      seed: () => const OnboardingActive(0),
      act: (cubit) => cubit.syncPage(2),
      expect: () => [const OnboardingActive(2)],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'is no-op when page is unchanged',
      build: () => OnboardingCubit(mockCompleteOnboarding),
      seed: () => const OnboardingActive(1),
      act: (cubit) => cubit.syncPage(1),
      expect: () => <OnboardingState>[],
    );
  });
}
