import 'package:baka_animestream/settings/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../helper/classes/anime_obj.dart';
import '../../helper/api.dart';
import './error.dart';
import '../widgets/detailsContent.dart';
import 'package:get/get.dart';

class AnimeDetail extends StatefulWidget {
  final AnimeClass animeObj;
  final Key heroTag;
  const AnimeDetail({super.key, required this.animeObj, required this.heroTag});

  @override
  State<AnimeDetail> createState() => _AnimeDetailState();
}

class _AnimeDetailState extends State<AnimeDetail> {
  Future<AnimeClass> setUp() async {
    var response = await searchAnime(title: widget.animeObj.title);
    AnimeClass obj = searchToObj(response[0]);
    return obj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 40,
        elevation: 0,
        leading: const BackButton(),
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
      // floatingActionButton: IconButton(
      //   style: ButtonStyle(
      //     fixedSize: MaterialStateProperty.all(Size(60, 60)),
      //     backgroundColor: MaterialStateProperty.all(
      //       Theme.of(context).colorScheme.secondary,
      //     ),
      //   ),
      //   onPressed: () => {},
      //   icon: Icon(
      //     Icons.play_arrow,
      //     color: Theme.of(context).colorScheme.onSecondary,
      //   ),
      // ),
    );
  }
}
