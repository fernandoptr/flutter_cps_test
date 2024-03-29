import 'package:flutter/material.dart';

import 'themes.dart';

class AppTheme {
  static const defaultBorderRadius = BorderRadius.all(Radius.circular(16.0));

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16.0),
      border: _border(Colors.grey.shade400),
      enabledBorder: _border(Colors.grey.shade400),
      focusedBorder: _border(Colors.blue, width: 2.0),
      errorBorder: _border(Colors.red, width: 2.0),
      focusedErrorBorder: _border(Colors.red, width: 2.0),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
