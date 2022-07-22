import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/api.dart';
import '../helper/animeClass.dart';
import '../widgets/animeCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var query = TextEditingController(text: "");
  bool loading = true;
  bool empty = true;
  List<AnimeObj> anime = [];

  void search() async {
    if (query.text.isEmpty) {
      setState(() {
        empty = true;
      });
      return;
    }

    setState(() {
      loading = true;
      empty = false;
    });
    anime.clear();
    var result = await searchAnime(query.text);
    result.asMap().forEach((index, value) {
      anime.add(searchToObj(value));
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CupertinoSearchTextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                placeholder: "Cerca anime",
                autofocus: false,
                controller: query,
                onSubmitted: (value) {
                  search();
                },
                onSuffixTap: () {
                  query.clear();
                  search();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              empty
                  ? const SizedBox(
                      height: 0,
                    )
                  : Text(
                      "${anime.length} risultati per \"${query.text}\"",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: empty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_outlined,
                            size: 80,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          Text(
                            "Cerca qualcosa",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      )
                    : loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : anime.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "¯\\༼ ಥ ‿ ಥ ༽/¯",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 40,
                                      ),
                                    ),
                                    Text(
                                      "Non ho trovato nulla",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                mainAxisSpacing: 0,
                                children: anime.map(
                                  (value) {
                                    return SizedBox(
                                      height: 300,
                                      child: AnimeCard(
                                        anime: value,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
