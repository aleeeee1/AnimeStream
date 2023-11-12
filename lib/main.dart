import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/pages/main_page.dart';
import 'package:baka_animestream/ui/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:baka_animestream/services/internal_db.dart';

import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  initMeeduPlayer();

  WidgetsFlutterBinding.ensureInitialized();

  ObjectBox objectBox = await ObjectBox.create();
  // objectBox.store.box<AnimeModel>().removeAll();
  Get.put(objectBox);

  InternalAPI internalApi = InternalAPI();
  await internalApi.initialize();
  Get.put(internalApi);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
      
    ),
  );

  runApp(const BakaApp());
}

class BakaApp extends StatelessWidget {
  const BakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicThemeBuilder(
      title: "Anime Stream",
      home: MainPage(),
    );
  }
}
