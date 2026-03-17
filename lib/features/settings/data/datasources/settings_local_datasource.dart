import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences wrapper for the user's locale preference.
///
/// Keeps data-access isolated from domain logic (per C033).
@lazySingleton
class SettingsLocalDatasource {
  SettingsLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const _localeKey = 'locale_code';

  /// Returns the persisted locale code, or `null` if never set.
  String? getLocaleCode() => _prefs.getString(_localeKey);

  /// Persists the given [localeCode].
  Future<bool> saveLocaleCode(String localeCode) =>
      _prefs.setString(_localeKey, localeCode);
}
