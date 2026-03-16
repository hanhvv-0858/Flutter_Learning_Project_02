import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'splash_state.dart';

/// Timer-based cubit that drives splash screen navigation.
/// Starts in [SplashAnimating] and emits [SplashComplete] after 2 seconds.
///
/// Registered as a factory so each [BlocProvider] gets a fresh instance.
@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashAnimating());

  /// Waits 2 seconds then signals the page to navigate away.
  Future<void> startAnimation() async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    // Guard against emitting on a closed cubit (e.g. widget was disposed).
    if (!isClosed) emit(const SplashComplete());
  }
}
