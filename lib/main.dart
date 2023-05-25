import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/pages/mainPage.dart';
import 'package:baka_animestream/ui/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:baka_animestream/services/internal_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InternalAPI internalApi = InternalAPI();
  await internalApi.initialize();

  ObjectBox objectBox = await ObjectBox.create();
  // objectBox.store.box<AnimeModel>().removeAll();

  Get.put(internalApi);
  Get.put(objectBox);

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
