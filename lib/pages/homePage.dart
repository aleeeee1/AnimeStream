import 'package:flutter/material.dart';

import '../helper/api.dart';
import '../widgets/animeRow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            AnimeRow(
              key: UniqueKey(),
              function: latestAnime(),
              name: "Ulime uscite",
              type: 0,
            ),
            const SizedBox(height: 15),
            AnimeRow(
              key: UniqueKey(),
              function: popularAnime(),
              name: "Anime popolari",
              type: 1,
            ),
            const SizedBox(height: 15),
            AnimeRow(
              function: searchAnime(""),
              name: "Tutti gli anime",
              type: 2,
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.popAndPushNamed(context, "/"),
              label: const Text("Aggiorna"),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
