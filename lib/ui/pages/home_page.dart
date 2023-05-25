import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/settings/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/api.dart';
import '../widgets/anime_row.dart';

class HomePage extends StatelessWidget {
  final InternalAPI internalAPI = Get.find<InternalAPI>();
  final GlobalKey<State<StatefulWidget>> continueKey = GlobalKey();

  final rows = [
    AnimeRow(
      key: UniqueKey(),
      function: toContinueAnime,
      name: "Riprendi a guardare",
      type: 3,
    ),
    AnimeRow(
      key: UniqueKey(),
      function: latestAnime,
      name: "Ulime uscite",
      type: 0,
    ),
    AnimeRow(
      key: UniqueKey(),
      function: popularAnime,
      name: "Anime popolari",
      type: 1,
    ),
    AnimeRow(
      key: UniqueKey(),
      function: searchAnime,
      name: "Tutti gli anime",
      type: 2,
    ),
  ];

  HomePage({super.key});

  refresh() async {
    Get.offAllNamed(RouteGenerator.mainPage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RefreshIndicator(
            onRefresh: () => refresh(),
            child: ListView.separated(
              itemBuilder: (context, index) => rows[index],
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: rows.length,
            ),
          ),
        ),
      ),
    );
  }
}
