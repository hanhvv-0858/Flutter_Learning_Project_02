import 'package:equatable/equatable.dart';

/// State emitted by [SettingsCubit] holding the current locale code.
class SettingsState extends Equatable {
  const SettingsState({this.localeCode});

  /// The active locale code (e.g. 'en', 'vi'). Null means system default.
  final String? localeCode;

  SettingsState copyWith({String? localeCode}) =>
      SettingsState(localeCode: localeCode);

  @override
  List<Object?> get props => [localeCode];
}
