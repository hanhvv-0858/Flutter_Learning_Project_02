import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:example_flutter_02/features/onboarding/data/repositories/onboarding_repository_impl.dart';

class MockOnboardingLocalDatasource extends Mock
    implements OnboardingLocalDatasource {}

void main() {
  late MockOnboardingLocalDatasource mockDatasource;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockOnboardingLocalDatasource();
    repository = OnboardingRepositoryImpl(mockDatasource);
  });

  group('checkOnboardingStatus()', () {
    test('returns Right(true) when datasource returns true', () async {
      when(
        () => mockDatasource.isOnboardingComplete(),
      ).thenAnswer((_) async => true);

      final result = await repository.checkOnboardingStatus();

      expect(result, const Right<Failure, bool>(true));
    });

    test('returns Right(false) when datasource returns false', () async {
      when(
        () => mockDatasource.isOnboardingComplete(),
      ).thenAnswer((_) async => false);

      final result = await repository.checkOnboardingStatus();

      expect(result, const Right<Failure, bool>(false));
    });

    test('returns Left(CacheFailure) when datasource throws', () async {
      when(
        () => mockDatasource.isOnboardingComplete(),
      ).thenThrow(Exception('SharedPreferences read error'));

      final result = await repository.checkOnboardingStatus();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('completeOnboarding()', () {
    test('returns Right(unit) when datasource succeeds', () async {
      when(() => mockDatasource.completeOnboarding()).thenAnswer((_) async {});

      final result = await repository.completeOnboarding();

      expect(result, const Right<Failure, Unit>(unit));
    });

    test('returns Left(CacheFailure) when datasource throws', () async {
      when(
        () => mockDatasource.completeOnboarding(),
      ).thenThrow(Exception('SharedPreferences write error'));

      final result = await repository.completeOnboarding();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('calls datasource.completeOnboarding() exactly once', () async {
      when(() => mockDatasource.completeOnboarding()).thenAnswer((_) async {});

      await repository.completeOnboarding();

      verify(() => mockDatasource.completeOnboarding()).called(1);
    });
  });
}
