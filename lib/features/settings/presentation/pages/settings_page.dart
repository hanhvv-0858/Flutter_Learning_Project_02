import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_state.dart';

/// Settings screen with language selection.
///
/// Reads the current locale from [SettingsCubit] and switches immediately
/// upon user tap. The change persists across restarts.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _supportedLocales = [
    _LocaleOption(code: 'en', label: 'English', flag: '🇺🇸'),
    _LocaleOption(code: 'vi', label: 'Tiếng Việt', flag: '🇻🇳'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => _LanguageSection(
          locales: _supportedLocales,
          selectedCode: state.localeCode ?? 'en',
        ),
      ),
    );
  }
}

/// Language selection section — extracted to keep [SettingsPage] nesting ≤ 4.
class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.locales, required this.selectedCode});

  final List<_LocaleOption> locales;
  final String selectedCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.settingsLanguage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...locales.map(
          (option) => _LocaleTile(
            option: option,
            isSelected: selectedCode == option.code,
          ),
        ),
      ],
    );
  }
}

/// A single locale row in the language list.
class _LocaleTile extends StatelessWidget {
  const _LocaleTile({required this.option, required this.isSelected});

  final _LocaleOption option;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(option.flag, style: const TextStyle(fontSize: 24)),
      title: Text(option.label),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () => context.read<SettingsCubit>().changeLocale(option.code),
    );
  }
}

class _LocaleOption {
  const _LocaleOption({
    required this.code,
    required this.label,
    required this.flag,
  });

  final String code;
  final String label;
  final String flag;
}
