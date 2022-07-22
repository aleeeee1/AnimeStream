import 'package:flutter/material.dart';

import './animeCard.dart';
import '../helper/animeClass.dart';

class AnimeRow extends StatefulWidget {
  final Future<List> function;
  final String name;
  final int type;
  const AnimeRow({
    super.key,
    required this.function,
    required this.name,
    required this.type,
  });

  @override
  State<AnimeRow> createState() => _AnimeRowState();
}

class _AnimeRowState extends State<AnimeRow> {
  late Function convert;
  late String name;
  @override
  Widget build(BuildContext context) {
    name = widget.name;
    switch (widget.type) {
      case 0:
        convert = latestToObj;
        break;
      case 1:
        convert = popularToObj;
        break;
      case 2:
        convert = searchToObj;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder(
            future: widget.function,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as List;
                return Scrollbar(
                  radius: const Radius.circular(360),
                  thickness: 3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return AnimeCard(
                        anime: convert(data[index]),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        "Qualcosa è andato storto :(",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 23,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => WidgetsBinding.instance
                            .addPostFrameCallback((_) => setState(() {})),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Riprova"),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
