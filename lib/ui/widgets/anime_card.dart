import 'package:baka_animestream/settings/routes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../helper/classes/anime_obj.dart';

class AnimeCard extends StatelessWidget {
  AnimeClass anime;
  final heroTag = UniqueKey();

  AnimeCard({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await Get.toNamed(
          RouteGenerator.loadAnime,
          arguments: [anime, heroTag],
        );
      },
      child: SizedBox(
        height: 280,
        width: 150,
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  color: Theme.of(context).colorScheme.background,
                  // width: 150,
                  height: 202,
                  child: Hero(
                    key: UniqueKey(),
                    tag: heroTag,
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 38,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Center(
                  child: Text(
                    anime.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.6,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
