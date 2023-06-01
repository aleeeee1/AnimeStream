import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/pages/main_page.dart';
import 'package:baka_animestream/ui/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:baka_animestream/services/internal_db.dart';

import 'package:flutter_meedu_videoplayer/meedu_player.dart';

void main() async {
  initMeeduPlayer();

  WidgetsFlutterBinding.ensureInitialized();

  ObjectBox objectBox = await ObjectBox.create();
  // objectBox.store.box<AnimeModel>().removeAll();
  Get.put(objectBox);

  InternalAPI internalApi = InternalAPI();
  await internalApi.initialize();
  Get.put(internalApi);

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
