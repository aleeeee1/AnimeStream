import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:baka_animestream/ui/pages/transition_page.dart';
import 'package:flutter/material.dart';

import 'package:baka_animestream/ui/pages/main_page.dart';
import 'package:baka_animestream/ui/pages/anime_detail.dart';
import 'package:baka_animestream/ui/pages/error_page.dart';
import 'package:baka_animestream/ui/pages/home_page.dart';

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
