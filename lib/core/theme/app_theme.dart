import 'package:flutter/material.dart';

/// Centralized app theme — all colors, text styles, and component themes
/// defined here so widgets never hardcode visual values.
///
/// Per C024: configuration centralized; per Constitution Principle II: ThemeData.
class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF6750A4);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
