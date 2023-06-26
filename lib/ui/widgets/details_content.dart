import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/ui/widgets/details_content_fragments/episode_tile.dart';
import 'package:baka_animestream/ui/widgets/episode_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';

import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:get/get.dart';

class DetailsContent extends StatefulWidget {
  final AnimeClass anime;
  final Key heroTag;
  const DetailsContent({super.key, required this.anime, required this.heroTag});

  @override
  State<DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<DetailsContent> {
  final ScrollController _controller = ScrollController();

  late final AnimeClass anime;
  late AnimeModel animeModel;

  late LoadingThings controller;
  late ResumeController resumeController;

  int getRemaining(int index) {
    if (animeModel.episodes
        .containsKey(anime.episodes[index]['id'].toString())) {
      var currTime =
          animeModel.episodes[anime.episodes[index]['id'].toString()][0];
      var totTime =
          animeModel.episodes[anime.episodes[index]['id'].toString()][1];

      return totTime - currTime;
    }

    return -1;
  }

  int getLatestIndex() {
    int index = animeModel.lastSeenEpisodeIndex ?? 0;
    print("index prima: $index");

    int remaining = getRemaining(index);

    if (remaining < 120 && remaining != -1) {
      index = index + 1;
    }

    index %= (anime.episodes.length - 1);
    print("index dopo: $index");
    return index;
  }

  @override
  void initState() {
    anime = widget.anime;
    animeModel = fetchAnimeModel(anime);
    controller = LoadingThings(
      anime: anime,
      animeModel: animeModel,
      index: animeModel.lastSeenEpisodeIndex ?? 0,
    );

    resumeController = ResumeController(
      anime: anime,
      index_: getLatestIndex(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  key: UniqueKey(),
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
                                  strokeAlign: BorderSide.strokeAlignOutside,
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ExpandableText(
            backgroundColor: Theme.of(context).colorScheme.background,
            boxShadow: const [],
            textWidget: Text(
              anime.description.length > 50
                  ? anime.description
                  : anime.description + " " * 50,
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
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            width: double.infinity,
            child: Obx(
              () => EpisodePlayer(
                anime: anime,
                controller: controller,
                resumeController: resumeController,
                resume: true,
                borderRadius: 90,
                height: 40,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.error.value
                          ? Icon(
                              Icons.error,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            )
                          : controller.loading.value
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Icon(
                                  Icons.play_arrow,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Riprendi",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ],

                    // child: ElevatedButton.icon(
                    //   style: ButtonStyle(
                    //     backgroundColor: MaterialStateProperty.all<Color>(
                    //       Theme.of(context).colorScheme.secondaryContainer,
                    //     ),
                    //   ),
                    //   onPressed: null,
                    //   icon: Icon(
                    //     Icons.play_arrow,
                    //     color: Theme.of(context).colorScheme.onSecondaryContainer,
                    //   ),
                    //   label: Text(
                    //     "Riprendi",
                    //     style: TextStyle(
                    //       color: Theme.of(context).colorScheme.onSecondaryContainer,
                    //     ),
                  ),
                ),
              ),
            ),
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
              return EpisodeTile(
                anime: anime,
                index: index,
                resumeController: resumeController,
              );
            },
          ),
        )
      ],
    );
  }
}

class ResumeController extends GetxController {
  final Rx<int> index;
  final AnimeClass anime;

  ResumeController({required int index_, required this.anime})
      : index = index_.obs;

  updateIndex() {
    AnimeModel animeModel = fetchAnimeModel(anime);
    index.value = animeModel.lastSeenEpisodeIndex ?? 0;

    debugPrint("updateIndex: ${index.value}");
    update();
  }
}
