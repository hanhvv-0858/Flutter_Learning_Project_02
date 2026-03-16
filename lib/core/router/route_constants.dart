/// Centralized route path constants for GoRouter.
/// Per C024: no hard-coded strings scattered throughout widget files.
class RouteConstants {
  RouteConstants._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String search = '/search';

  /// GoRouter route pattern for album detail.
  static const String detailPath = '/detail/:id';

  /// Generates the navigable URL for a specific album.
  static String detailRoute(String albumId) => '/detail/$albumId';
}
