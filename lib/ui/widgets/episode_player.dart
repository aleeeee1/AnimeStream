import 'package:baka_animestream/ui/widgets/details_content_fragments/episode_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/widgets/player.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:baka_animestream/services/internal_db.dart';
import 'package:baka_animestream/helper/models/anime_model.dart';

class EpisodePlayer extends StatefulWidget {
  final AnimeClass anime;
  final AnimeModel animeModel;

  final Widget child;
  final int index;

  final LoadingThings controller;
  final int? borderRadius;

  const EpisodePlayer({
    super.key,
    required this.child,
    required this.anime,
    required this.index,
    required this.animeModel,
    required this.controller,
    this.borderRadius,
  });

  @override
  State<EpisodePlayer> createState() => _EpisodePlayerState();
}

class _EpisodePlayerState extends State<EpisodePlayer> {
  late WebViewPlusController theController;

  late AnimeModel animeModel;
  late AnimeClass anime;
  late int index;

  Widget? fantasticWidget;
  InternalAPI internalAPI = Get.find<InternalAPI>();

  @override
  void initState() {
    anime = widget.anime;
    index = widget.index;
    animeModel = widget.animeModel;

    if (kDebugMode) ('$index ${animeModel.lastSeenEpisodeIndex}');

    super.initState();
  }

  void initWebView() async {
    fantasticWidget = SizedBox(
      height: 63,
      child: Offstage(
        offstage: true,
        child: WebViewPlus(
          userAgent:
              "Mozilla/5.0 (Linux; Android 11; SAMSUNG SM-G973U) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/14.2 Chrome/87.0.4280.141 Mobile Safari/537.36",
          initialUrl:
              "https://www.animeunity.it/anime/${anime.id}-${anime.slug}/${anime.episodes[index]['id']}",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) async {
            theController = controller;
          },
          onPageFinished: (_) async {
            await Future.delayed(Duration(seconds: internalAPI.getWaitTime()));
            var link = await theController.webViewController
                .runJavascriptReturningResult(
              'document.querySelector("a.plyr__controls__item")["href"]',
            );

            link = link.replaceAll('"', '');
            if (kDebugMode) {
              print(
                "Link: ${await theController.webViewController.currentUrl()}",
              );
              print("Link: $link");
            }

            setLoading(false);
            if (link.isNotEmpty) {
              openPlayer(link);
            } else {
              setError(true);
            }

            setState(() {
              fantasticWidget = null;
            });
          },
        ),
      ),
    );

    setState(() {});
  }

  void setError(bool value) {
    widget.controller.setError(value);
  }

  void setLoading(bool value) {
    widget.controller.setLoading(value);
  }

  Future<bool> isLinkOk(String link) async {
    try {
      final response = await http.head(Uri.parse(link));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void openPlayer(String link) async {
    await Get.to(
      () => PlayerPage(
        url: link,
        colorScheme: Theme.of(context).colorScheme,
        animeId: anime.id,
        episodeId: anime.episodes[index]['id'],
      ),
    );
    widget.controller.updateProgress();
  }

  void trackProgress() {
    animeModel.lastSeenDate = DateTime.now();
    animeModel.lastSeenEpisodeIndex = index;

    Get.find<ObjectBox>().store.box<AnimeModel>().put(animeModel);
  }

  void handleClick() async {
    var link = anime.episodes[index]['link'];
    trackProgress();

    if (!await isLinkOk(link)) {
      initWebView();
    } else {
      setLoading(false);
      openPlayer(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(
            widget.borderRadius?.toDouble() ?? 0,
          ),
          onTap: () {
            setLoading(true);
            setError(false);

            handleClick();
          },
          child: widget.child,
        ),
        fantasticWidget ?? const SizedBox(),
      ],
    );
  }
}
