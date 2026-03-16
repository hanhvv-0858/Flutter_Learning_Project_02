import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local datasource that persists the onboarding completion flag via
/// [SharedPreferences].
///
/// The single key `_kOnboardingCompleted` is the source of truth used by both
/// [OnboardingRepositoryImpl] and the GoRouter redirect guard.
@lazySingleton
class OnboardingLocalDatasource {
  OnboardingLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _kOnboardingCompleted = 'onboarding_completed';

  /// Returns `true` if the user has already completed the onboarding tutorial.
  Future<bool> isOnboardingComplete() async {
    try {
      return _prefs.getBool(_kOnboardingCompleted) ?? false;
    } catch (e, st) {
      debugPrint(
        'OnboardingLocalDatasource.isOnboardingComplete error: $e\n$st',
      );
      rethrow;
    }
  }

  /// Persists the onboarding completion flag so future launches skip the tutorial.
  Future<void> completeOnboarding() async {
    try {
      await _prefs.setBool(_kOnboardingCompleted, true);
    } catch (e, st) {
      debugPrint('OnboardingLocalDatasource.completeOnboarding error: $e\n$st');
      rethrow;
    }
  }
}
