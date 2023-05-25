import 'package:baka_animestream/settings/routes.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:baka_animestream/theme.dart';

class DynamicThemeBuilder extends StatelessWidget {
  const DynamicThemeBuilder({
    Key? key,
    required this.title,
    required this.home,
  }) : super(key: key);
  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final ThemeData lightDynamicTheme = ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme?.harmonized(),
        );
        final ThemeData darkDynamicTheme = ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme?.harmonized(),
        );
        return DynamicTheme(
          themeCollection: ThemeCollection(
            themes: {
              0: lightCustomTheme,
              1: darkCustomTheme,
              2: lightDynamicTheme,
              3: darkDynamicTheme,
            },
            fallbackTheme: lightCustomTheme,
          ),
          builder: (context, theme) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: theme,
            home: home,
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: RouteGenerator.mainPage,
          ),
        );
      },
    );
  }
}
