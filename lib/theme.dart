import 'package:flutter/material.dart';

var ilColore = Colors.black;

var lightCustomColorScheme = ColorScheme.fromSeed(
  seedColor: ilColore,
);

var lightCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightCustomColorScheme,
);

var darkCustomColorScheme = ColorScheme.fromSeed(
  seedColor: ilColore,
  brightness: Brightness.dark,
  // primary: ilColore,
  // surface: const Color(0xff1B1A1D),
);

var darkCustomTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkCustomColorScheme,
  // navigationBarTheme: NavigationBarThemeData(
  //   labelTextStyle: MaterialStateProperty.all(
  //     TextStyle(
  //       color: darkCustomColorScheme.onSurface,
  //       fontWeight: FontWeight.w500,
  //     ),
  //   ),
  // ),
  // canvasColor: const Color(0xff1B1A1D),
  // scaffoldBackgroundColor: const Color(0xff1B1A1D),
);

extension ColorExtension on Color {
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }
}
