import 'package:baka_animestream/widgets/animeFetchError.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../helper/animeClass.dart';
import '../helper/api.dart';
import './error.dart';
import './animeDetail.dart';

class LoadingPageForAnime extends StatefulWidget {
  final AnimeObj animeObj;
  final Key heroTag;
  const LoadingPageForAnime(
      {super.key, required this.animeObj, required this.heroTag});

  @override
  State<LoadingPageForAnime> createState() => LoadingPageForAnimeState();
}

class LoadingPageForAnimeState extends State<LoadingPageForAnime> {
  bool error = false;
  Future<void> setUp() async {
    try {
      var response = await searchAnime(widget.animeObj.title);
      AnimeObj obj = searchToObj(response[0]);
      push(obj.id == widget.animeObj.id, obj);
    } catch (e) {
      Navigator.pushNamed(context, "/error");
    }
  }

  void push(bool equal, AnimeObj animeObj) {
    equal
        ? Navigator.popAndPushNamed(
            context,
            "/anime",
            arguments: [
              animeObj,
              widget.heroTag,
            ],
          )
        : error = true;
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: error
          ? LilError(animeObj: widget.animeObj, heroTag: widget.heroTag)
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          key: UniqueKey(),
                          tag: widget.heroTag,
                          child: CachedNetworkImage(
                            imageUrl: widget.animeObj.imageUrl,
                            height: 280,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.animeObj.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Caricamento...',
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
