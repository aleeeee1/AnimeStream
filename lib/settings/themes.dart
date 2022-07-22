import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: scheme,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme = darkColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
        );
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: scheme,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
