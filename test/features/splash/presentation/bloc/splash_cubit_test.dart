import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_learning_project_2/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:flutter_learning_project_2/features/splash/presentation/bloc/splash_state.dart';

void main() {
  group('SplashCubit', () {
    late SplashCubit cubit;

    setUp(() => cubit = SplashCubit());
    tearDown(() => cubit.close());

    test('initial state is SplashAnimating', () {
      expect(cubit.state, isA<SplashAnimating>());
    });

    blocTest<SplashCubit, SplashState>(
      'emits [SplashComplete] after startAnimation()',
      build: () => SplashCubit(),
      act: (cubit) => cubit.startAnimation(),
      // Allow enough time for the 2-second delay
      wait: const Duration(milliseconds: 2100),
      expect: () => [isA<SplashComplete>()],
    );

    blocTest<SplashCubit, SplashState>(
      'does not emit after cubit is closed',
      build: () => SplashCubit(),
      act: (cubit) async {
        // Close immediately before the delay completes
        final future = cubit.startAnimation();
        await cubit.close();
        // Await the future to avoid dangling async — it should not emit
        await future;
      },
      expect: () => <SplashState>[],
    );
  });
}
