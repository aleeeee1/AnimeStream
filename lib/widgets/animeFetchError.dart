import 'package:flutter/material.dart';

import '../helper/animeClass.dart';

class LilError extends StatefulWidget {
  final AnimeObj animeObj;
  final Key heroTag;
  const LilError({super.key, required this.animeObj, required this.heroTag});

  @override
  State<LilError> createState() => _LilErrorState();
}

class _LilErrorState extends State<LilError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "щ(ºДºщ)",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 70,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            "Qualcosa è andato storto :(",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 23,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed(
              "/load_anime",
              arguments: [widget.animeObj, widget.heroTag],
            ),
            icon: const Icon(Icons.refresh),
            label: const Text("Riprova"),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Torna alla Home"),
          ),
        ],
      ),
    );
    ;
  }
}
