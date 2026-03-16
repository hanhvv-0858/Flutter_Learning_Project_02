/// Splash screen states.
sealed class SplashState {
  const SplashState();
}

/// Logo animation is playing.
class SplashAnimating extends SplashState {
  const SplashAnimating();
}

/// Animation finished — navigation to next screen should happen.
class SplashComplete extends SplashState {
  const SplashComplete();
}
