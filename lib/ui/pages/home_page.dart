import 'package:animestream/services/internal_api.dart';
import 'package:animestream/settings/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/api.dart';
import '../widgets/anime_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InternalAPI internalAPI = Get.find<InternalAPI>();

  final GlobalKey<State<StatefulWidget>> continueKey = GlobalKey();

  final rows = [
    AnimeRow(
      key: UniqueKey(),
      function: toContinueAnime,
      name: "Riprendi a guardare",
      type: 3,
    ),
    const AnimeRow(
      function: latestAnime,
      name: "Ulime uscite",
      type: 0,
    ),
    const AnimeRow(
      function: popularAnime,
      name: "Anime popolari",
      type: 1,
    ),
    const AnimeRow(
      function: searchAnime,
      name: "Tutti gli anime",
      type: 2,
    ),
  ];

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
