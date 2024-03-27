import 'package:animestream/helper/api.dart';
import 'package:animestream/services/internal_api.dart';
import 'package:animestream/ui/widgets/details_content.dart';
import 'package:animestream/ui/widgets/episode_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:animestream/helper/classes/anime_obj.dart';

import 'package:animestream/services/internal_db.dart';
import 'package:animestream/helper/models/anime_model.dart';
import 'package:animestream/objectbox.g.dart';

class EpisodeTile extends StatefulWidget {
  final AnimeClass anime;
  final int index;

  final ResumeController resumeController;

  const EpisodeTile({super.key, required this.anime, required this.index, required this.resumeController});

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  InternalAPI internalAPI = Get.find<InternalAPI>();
  late LoadingThings loading;

  late AnimeClass anime;
  late int index;

  Widget? fantasticWidget;
  Box objBox = Get.find<ObjectBox>().store.box<AnimeModel>();

  late AnimeModel animeModel;

  @override
  void initState() {
    super.initState();

    anime = widget.anime;
    index = widget.index;
    animeModel = fetchAnimeModel(anime);

    loading = LoadingThings(anime: anime, index: index, animeModel: animeModel);
    loading.updateProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        EpisodePlayer(
          resumeController: widget.resumeController,
          anime: anime,
          index: index,
          controller: loading,
          borderRadius: 7,
          child: Container(
            height: 63,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(60),
              borderRadius: const BorderRadius.all(
                Radius.circular(7),
              ),
            ),
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
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${anime.episodes[index]['visite']} visualizzazioni",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Obx(
                    () => loading.error.value
                        ? Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : loading.loading.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => loading.progress.value > 0
              ? Container(
                  padding: const EdgeInsets.only(
                    left: 1,
                    right: 1,
                  ),
                  height: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                    child: LinearProgressIndicator(
                      value: loading.progress.value,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        // getProgress() > 0
        //     ? Container(
        //         padding: const EdgeInsets.only(
        //           left: 1,
        //           right: 1,
        //         ),
        //         height: 3,
        //         child: ClipRRect(
        //           borderRadius: const BorderRadius.all(
        //             Radius.circular(7),
        //           ),
        //           child: LinearProgressIndicator(
        //             value: getProgress(),
        //           ),
        //         ),
        //       )
        //     : const SizedBox(),
      ],
    );
  }
}

class LoadingThings extends GetxController {
  final AnimeClass anime;
  final int index;
  AnimeModel animeModel;

  LoadingThings({
    required this.anime,
    required this.index,
    required this.animeModel,
  }) {
    lastIndex = animeModel.lastSeenEpisodeIndex?.obs ?? 0.obs;
  }

  var loading = false.obs;
  var error = false.obs;
  var progress = 0.0.obs;
  late Rx<int> lastIndex;

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  void setError(bool value) {
    error.value = value;
    update();
  }

  void updateProgress() {
    animeModel = fetchAnimeModel(anime);
    progress.value = getProgress();
    debugPrint("Progress: $progress");
    update();
  }

  updateIndex() {
    animeModel = fetchAnimeModel(anime);
    lastIndex.value = animeModel.lastSeenEpisodeIndex ?? 0;

    debugPrint("Last Index: $lastIndex");
    update();
  }

  double getProgress() {
    if (animeModel.episodes.containsKey(anime.episodes[index]['id'].toString())) {
      var currTime = animeModel.episodes[anime.episodes[index]['id'].toString()][0];
      var totTime = animeModel.episodes[anime.episodes[index]['id'].toString()][1];

      return (currTime / totTime);
    }

    return (0);
  }
}
