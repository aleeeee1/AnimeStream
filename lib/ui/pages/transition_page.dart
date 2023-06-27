import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:baka_animestream/settings/routes.dart';
import 'package:baka_animestream/ui/widgets/anime_fetch_error.dart';

class LoadingPageForAnime extends StatefulWidget {
  final AnimeClass animeObj;
  final Key heroTag;
  const LoadingPageForAnime({
    super.key,
    required this.animeObj,
    required this.heroTag,
  });

  @override
  State<LoadingPageForAnime> createState() => LoadingPageForAnimeState();
}

class LoadingPageForAnimeState extends State<LoadingPageForAnime> {
  bool error = false;
  Future<void> setUp() async {
    try {
      var response = await searchAnime(title: widget.animeObj.title);
      push(response);
    } catch (e) {
      Get.toNamed(
        RouteGenerator.error,
      );
    }
  }

  void push(List<dynamic> response) {
    for (var anime in response) {
      if (searchToObj(anime).id == widget.animeObj.id) {
        Get.offNamed(
          RouteGenerator.animeDetail,
          arguments: [
            searchToObj(anime),
            widget.heroTag,
          ],
        );
        return;
      }
    }

    setState(() {
      error = true;
    });
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Flexible(
                            child: Text(
                              widget.animeObj.title,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
