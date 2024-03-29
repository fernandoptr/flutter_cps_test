import 'package:flutter/material.dart';

import 'themes.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
    );
  }
}
