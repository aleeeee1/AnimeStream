import 'package:flutter/material.dart';
import "package:dynamic_color/dynamic_color.dart";

import './settings/themes.dart';
import './settings/routes.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BakaApp());
}

class BakaApp extends StatelessWidget {
  const BakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(lightDynamic),
        darkTheme: AppTheme.darkTheme(darkDynamic),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [HeroController()],
      ),
    );
  }
}
