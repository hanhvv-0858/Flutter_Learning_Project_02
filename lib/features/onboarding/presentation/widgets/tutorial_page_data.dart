import 'package:flutter/material.dart';

import 'package:example_flutter_02/core/l10n/app_localizations.dart';

/// Data model for a single onboarding tutorial page.
/// Strings are resolved from [AppLocalizations] so they update on locale change.
class TutorialPageData {
  final String title;
  final String description;
  final IconData icon;

  const TutorialPageData({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Returns all 3 tutorial pages with localized strings.
  static List<TutorialPageData> getPages(AppLocalizations l10n) => [
    TutorialPageData(
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDesc1,
      icon: Icons.music_note_rounded,
    ),
    TutorialPageData(
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDesc2,
      icon: Icons.favorite_rounded,
    ),
    TutorialPageData(
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDesc3,
      icon: Icons.search_rounded,
    ),
  ];
}
