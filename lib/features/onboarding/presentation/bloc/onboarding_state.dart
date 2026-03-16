/// Onboarding Cubit states.
sealed class OnboardingState {
  const OnboardingState();
}

/// The tutorial is active on the given [currentPage] index (0-based).
class OnboardingActive extends OnboardingState {
  final int currentPage;
  const OnboardingActive(this.currentPage);
}

/// User completed or skipped the tutorial — navigate to Home.
class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}
