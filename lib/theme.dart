import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData quickChatLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: darkPrimaryColor,
      onPrimary: primaryTextColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    scaffoldBackgroundColor: secondaryColor,
  );
}
