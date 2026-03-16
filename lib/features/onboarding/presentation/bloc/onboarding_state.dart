import 'package:equatable/equatable.dart';

/// Onboarding Cubit states.
sealed class OnboardingState {
  const OnboardingState();
}

/// The tutorial is active on the given [currentPage] index (0-based).
final class OnboardingActive extends OnboardingState with EquatableMixin {
  final int currentPage;
  const OnboardingActive(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}

/// User completed or skipped the tutorial — navigate to Home.
final class OnboardingComplete extends OnboardingState with EquatableMixin {
  const OnboardingComplete();

  @override
  List<Object?> get props => [];
}
