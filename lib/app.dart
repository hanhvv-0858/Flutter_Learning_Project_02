import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:example_flutter_02/core/di/injection.dart';
import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/core/router/app_router.dart';
import 'package:example_flutter_02/core/theme/app_theme.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_state.dart';

/// Root application widget.
/// Wires together routing (GoRouter), theme (AppTheme), and localization.
/// Listens to [SettingsCubit] to rebuild with the selected locale.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: AppTheme.lightTheme,
            locale: settingsState.localeCode != null
                ? Locale(settingsState.localeCode!)
                : null,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
