import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/core/router/app_router.dart';
import 'package:example_flutter_02/core/theme/app_theme.dart';

/// Root application widget.
/// Wires together routing (GoRouter), theme (AppTheme), and localization.
/// Locale switching (Phase 9) will update this widget via SettingsCubit.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
