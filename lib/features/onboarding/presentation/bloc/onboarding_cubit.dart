import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'onboarding_state.dart';

/// Manages onboarding tutorial page navigation and completion.
///
/// Registered as a factory — a fresh instance is created per [BlocProvider],
/// allowing the PageView to start fresh every time the route is pushed.
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._completeOnboarding) : super(const OnboardingActive(0));

  final CompleteOnboarding _completeOnboarding;

  /// Advances to the next page, or completes the tutorial on the last page.
  Future<void> nextPage(int totalPages) async {
    final current = state;
    if (current is! OnboardingActive) return;

    if (current.currentPage < totalPages - 1) {
      emit(OnboardingActive(current.currentPage + 1));
    } else {
      await _complete();
    }
  }

  /// Syncs cubit page when user swipes the [PageView] directly.
  /// No-op if already on the requested page to avoid listener loops.
  void syncPage(int page) {
    final current = state;
    if (current is OnboardingActive && current.currentPage != page) {
      emit(OnboardingActive(page));
    }
  }

  /// Skips the remaining pages and completes the tutorial immediately.
  Future<void> skip() async => _complete();

  Future<void> _complete() async {
    final result = await _completeOnboarding(NoParams());

    result.fold((failure) {
      // C029: log failure with context but do not block navigation.
      log(
        'Failed to persist onboarding completion: ${failure.message}',
        name: 'OnboardingCubit',
      );
      emit(const OnboardingComplete());
    }, (_) => emit(const OnboardingComplete()));
  }
}
