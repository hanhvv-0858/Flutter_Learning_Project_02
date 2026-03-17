import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/settings/domain/usecases/change_locale.dart';
import 'package:example_flutter_02/features/settings/domain/usecases/get_current_locale.dart';
import 'settings_state.dart';

/// Cubit managing the app-wide locale preference.
///
/// Reads persisted locale on [loadLocale] and persists + emits on
/// [changeLocale]. Registered as a lazy singleton so the same instance
/// is shared between SettingsPage and the root App widget.
@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._getCurrentLocale, this._changeLocale)
    : super(const SettingsState());

  final GetCurrentLocale _getCurrentLocale;
  final ChangeLocale _changeLocale;

  /// Loads the persisted locale and emits the result.
  Future<void> loadLocale() async {
    final result = await _getCurrentLocale(NoParams());
    result.fold(
      (failure) => log(
        'loadLocale failed [${failure.runtimeType}]: ${failure.message}',
        name: 'SettingsCubit',
      ),
      (code) => emit(SettingsState(localeCode: code)),
    );
  }

  /// Persists the new [localeCode] and updates the state.
  Future<void> changeLocale(String localeCode) async {
    final result = await _changeLocale(ChangeLocaleParam(localeCode));
    result.fold(
      (failure) => log(
        'changeLocale failed [${failure.runtimeType}]: ${failure.message}',
        name: 'SettingsCubit',
      ),
      (_) => emit(SettingsState(localeCode: localeCode)),
    );
  }
}
