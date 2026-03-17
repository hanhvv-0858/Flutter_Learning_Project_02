import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/settings/domain/usecases/change_locale.dart';
import 'package:example_flutter_02/features/settings/domain/usecases/get_current_locale.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_state.dart';

class MockGetCurrentLocale extends Mock implements GetCurrentLocale {}

class MockChangeLocale extends Mock implements ChangeLocale {}

void main() {
  late MockGetCurrentLocale mockGetCurrentLocale;
  late MockChangeLocale mockChangeLocale;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const ChangeLocaleParam(''));
  });

  setUp(() {
    mockGetCurrentLocale = MockGetCurrentLocale();
    mockChangeLocale = MockChangeLocale();
  });

  SettingsCubit buildCubit() =>
      SettingsCubit(mockGetCurrentLocale, mockChangeLocale);

  group('initial state', () {
    test('has null localeCode', () {
      final cubit = buildCubit();
      expect(cubit.state, const SettingsState());
      expect(cubit.state.localeCode, isNull);
      cubit.close();
    });
  });

  group('loadLocale()', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits SettingsState with persisted locale on success',
      build: () {
        when(
          () => mockGetCurrentLocale(any()),
        ).thenAnswer((_) async => const Right('vi'));
        return buildCubit();
      },
      act: (cubit) => cubit.loadLocale(),
      expect: () => [const SettingsState(localeCode: 'vi')],
    );

    blocTest<SettingsCubit, SettingsState>(
      'emits SettingsState with null when no locale saved',
      build: () {
        when(
          () => mockGetCurrentLocale(any()),
        ).thenAnswer((_) async => const Right(null));
        return buildCubit();
      },
      act: (cubit) => cubit.loadLocale(),
      expect: () => [const SettingsState(localeCode: null)],
    );

    blocTest<SettingsCubit, SettingsState>(
      'does not emit on failure (logs only)',
      build: () {
        when(
          () => mockGetCurrentLocale(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('read error')));
        return buildCubit();
      },
      act: (cubit) => cubit.loadLocale(),
      expect: () => <SettingsState>[],
    );
  });

  group('changeLocale()', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits updated locale on success',
      build: () {
        when(
          () => mockChangeLocale(any()),
        ).thenAnswer((_) async => const Right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.changeLocale('vi'),
      expect: () => [const SettingsState(localeCode: 'vi')],
    );

    blocTest<SettingsCubit, SettingsState>(
      'does not emit on failure (logs only)',
      build: () {
        when(
          () => mockChangeLocale(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('write error')));
        return buildCubit();
      },
      act: (cubit) => cubit.changeLocale('vi'),
      expect: () => <SettingsState>[],
    );
  });
}
