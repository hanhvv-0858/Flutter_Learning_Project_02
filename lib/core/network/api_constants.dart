/// Centralized API constants for all iTunes endpoints.
/// Per C024: all configuration values in one place, no hardcoded strings in code.
class ApiConstants {
  ApiConstants._();

  // --- iTunes RSS Feed ---
  static const String rssBaseUrl = 'https://itunes.apple.com';

  /// Top albums RSS feed. Replace {country} and {limit}.
  static String getTopAlbumsPath({String country = 'us', int limit = 50}) =>
      '/$country/rss/topalbums/limit=$limit/json';

  // --- iTunes Search API ---
  static const String searchBaseUrl = 'https://itunes.apple.com';
  static const String searchPath = '/search';

  // --- iTunes Lookup API ---
  static const String lookupBaseUrl = 'https://itunes.apple.com';
  static const String lookupPath = '/lookup';

  // --- Timeouts ---
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
