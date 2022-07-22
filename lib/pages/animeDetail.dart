import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helper/animeClass.dart';
import '../helper/api.dart';
import './error.dart';
import '../widgets/detailsContent.dart';

class AnimeDetail extends StatefulWidget {
  final AnimeObj animeObj;
  final Key heroTag;
  const AnimeDetail({super.key, required this.animeObj, required this.heroTag});

  @override
  State<AnimeDetail> createState() => _AnimeDetailState();
}

class _AnimeDetailState extends State<AnimeDetail> {
  Future<AnimeObj> setUp() async {
    var response = await searchAnime(widget.animeObj.title);
    AnimeObj obj = searchToObj(response[0]);
    return obj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 30,
        elevation: 0,
        leading: BackButton(
          onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).popUntil(
              ModalRoute.withName("/"),
            );
          }),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: DetailsContent(
            anime: widget.animeObj,
            heroTag: widget.heroTag,
          ),
        ),
      ),
    );
  }
}
