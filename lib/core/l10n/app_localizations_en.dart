// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Music Discovery';

  @override
  String get onboardingTitle1 => 'Discover Music';

  @override
  String get onboardingDesc1 =>
      'Browse the top albums from iTunes and find your next favorite artist.';

  @override
  String get onboardingTitle2 => 'Save Your Favorites';

  @override
  String get onboardingDesc2 =>
      'Bookmark albums you love and enjoy them offline, anytime.';

  @override
  String get onboardingTitle3 => 'Search & Explore';

  @override
  String get onboardingDesc3 =>
      'Search millions of albums and discover something new every day.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get homeTitle => 'Top Albums';

  @override
  String get homeErrorMessage => 'Failed to load albums. Please try again.';

  @override
  String get homeRetry => 'Retry';

  @override
  String get detailTracksHeader => 'Tracks';

  @override
  String get detailNoTracks => 'No tracks available.';

  @override
  String get detailSaved => 'Saved to Favorites';

  @override
  String get detailRemoved => 'Removed from Favorites';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorites yet. Save albums from the detail screen!';

  @override
  String get favoritesDeleteConfirm => 'Removed from favorites';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get searchPlaceholder => 'Search albums...';

  @override
  String get searchNoResults => 'No albums found. Try a different search.';

  @override
  String get searchError => 'Search failed. Please try again.';
}
