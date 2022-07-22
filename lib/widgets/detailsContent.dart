import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:expandable_widgets/expandable_widgets.dart';

import './player.dart';
import '../helper/animeClass.dart';

class DetailsContent extends StatefulWidget {
  final AnimeObj anime;
  final Key heroTag;
  const DetailsContent({super.key, required this.anime, required this.heroTag});

  @override
  State<DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<DetailsContent> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    AnimeObj anime = widget.anime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Hero(
                  tag: widget.heroTag,
                  child: CachedNetworkImage(
                    height: 170,
                    imageUrl: anime.imageUrl,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        runSpacing: 4,
                        spacing: 4,
                        children: [
                          for (var a in anime.genres)
                            Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              labelPadding: const EdgeInsets.only(
                                top: -6,
                                bottom: -6,
                                left: 5,
                                right: 5,
                              ),
                              padding: const EdgeInsets.all(0),
                              label: Text(
                                a['name'],
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 12.5,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: const BorderSide(
                                  strokeAlign: StrokeAlign.outside,
                                ),
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          "${anime.status} - ${anime.episodesCount != 0 ? anime.episodesCount : "??"} episodi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ExpandableText(
            backgroundColor: Theme.of(context).colorScheme.background,
            boxShadow: [],
            textWidget: Text(
              anime.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 15,
              ),
            ).copyWith(maxLines: 3),
            arrowWidget: Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            arrowLocation: ArrowLocation.bottom,
            finalArrowLocation: ArrowLocation.bottom,
            animationDuration: const Duration(milliseconds: 300),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onDoubleTap: () {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            onTap: () {
              _controller.animateTo(
                _controller.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              "${anime.episodes.length} episodi disponibili",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).colorScheme.background,
              height: 6,
              thickness: 0,
            ),
            itemCount: anime.episodes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PlayerPage(
                        url: anime.episodes[index]['link'],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withAlpha(60),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Episodio ${anime.episodes[index]['number']}",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "${anime.episodes[index]['visite']} visualizzazioni",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.play_arrow,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
