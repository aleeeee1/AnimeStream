import 'package:flutter/material.dart';

import '../ui/pages/homePage.dart';
import '../ui/pages/animeDetail.dart';
import '../ui/pages/error.dart';
import '../ui/pages/mainPage.dart';
import '../ui/pages/transitionPage.dart';
import '../helper/classes/anime_obj.dart';

class RouteGenerator {
  static const String mainPage = '/';
  static const String homePage = '/home';
  static const String animeDetail = '/anime';
  static const String loadAnime = '/load_anime';
  static const String error = '/error';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    List? args = settings.arguments as List?;

    switch (settings.name) {
      case mainPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const MainPage(),
        );
      case homePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => HomePage(),
        );
      case animeDetail:
        if (args![0] is AnimeClass && args[1] is Key) {
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => AnimeDetail(
              animeObj: args[0],
              heroTag: args[1],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const ErrorPage());
      case loadAnime:
        if (args![0] is AnimeClass && args[1] is Key) {
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => LoadingPageForAnime(
              animeObj: args[0],
              heroTag: args[1],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const ErrorPage());
      case error:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
    }
  }
}
