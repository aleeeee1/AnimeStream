import 'package:animestream/helper/api.dart';
import 'package:animestream/ui/widgets/details_content.dart';
import 'package:animestream/ui/widgets/details_content_fragments/episode_tile.dart';
import 'package:flutter/material.dart';
import 'package:animestream/services/internal_api.dart';
import 'package:animestream/ui/widgets/player.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:animestream/helper/classes/anime_obj.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:animestream/services/internal_db.dart';
import 'package:animestream/helper/models/anime_model.dart';

class EpisodePlayer extends StatefulWidget {
  final AnimeClass anime;

  final Widget child;
  final int? index;

  final LoadingThings controller;
  final ResumeController resumeController;

  final int? borderRadius;
  final double height;

  final bool resume;

  const EpisodePlayer({
    super.key,
    required this.child,
    required this.anime,
    this.index,
    required this.controller,
    required this.resumeController,
    this.borderRadius,
    this.height = 63,
    this.resume = false,
  });

  @override
  State<EpisodePlayer> createState() => _EpisodePlayerState();
}

class _EpisodePlayerState extends State<EpisodePlayer> {
  late WebViewController theController;

  late AnimeClass anime;
  late int index;

  Widget? fantasticWidget;
  InternalAPI internalAPI = Get.find<InternalAPI>();

  bool redirected = false;
  bool alreadyLoaded = false;
  @override
  void initState() {
    anime = widget.anime;
    index = widget.index ?? 0;

    theController = WebViewController()
      ..setUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 Edg/123.0.2420.81')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            Uri uri = Uri.parse(request.url);
            if (uri.host.contains("www.animeunity.") || uri.host.contains("scws-content.net")) {
              debugPrint("Navigating to: ${uri}");
              return NavigationDecision.navigate;
            } else {
              debugPrint("Preventing navigation to: ${uri}");
              return NavigationDecision.prevent;
            }
          },
          onUrlChange: (url) {
            debugPrint("url changed in: ${url.url}");
          },
          onPageFinished: (url) {
            debugPrint("Page finished: ${url}");
            loadUrl();
          },
        ),
      );

    super.initState();
  }

  Future<void> loadUrl() async {
    debugPrint("Called loadURL");

    if (alreadyLoaded) return;
    alreadyLoaded = true;

    var res = await theController.runJavaScriptReturningResult("document.location.href");
    int tries = 0;
    while (res == "\"about:blank\"" && tries < 5) {
      await Future.delayed(Duration(seconds: 1));
      tries++;

      res = await theController.runJavaScriptReturningResult("document.location.href");
      res = res.toString();
    }

    if (res == "\"about:blank\"") {
      setError(true);
    } else {
      debugPrint("Loaded URL: $res");

      if (!redirected) {
        redirected = true;

        var videoLink = await theController.runJavaScriptReturningResult('document.getElementsByTagName("iframe")[0].src');
        videoLink = videoLink.toString();

        debugPrint("Video link: $videoLink");

        if (videoLink == "null") {
          setError(true);
        } else {
          theController.loadRequest(Uri.parse(videoLink.toString().replaceAll("\"", "")));
        }

        alreadyLoaded = false;
        return;
      }

      String link = (await theController.runJavaScriptReturningResult("window.downloadUrl")).toString();
      link = link.replaceAll("\"", "");

      if (link == "null" || !await isLinkOk(link)) {
        setError(true);
      } else {
        openPlayer(link);
      }
    }

    alreadyLoaded = false;
    setLoading(false);
    setState(() {
      fantasticWidget = null;
    });
  }

  void initWebView() async {
    fantasticWidget = SizedBox(
      height: widget.height,
      child: Offstage(
        offstage: true,
        child: WebViewWidget(
          controller: theController,
        ),
      ),
    );
    setState(() {});

    Uri url = Uri.parse("https://www.animeunity.it/anime/${anime.id}-${anime.slug}/${anime.episodes[index]['id']}");
    await theController.loadRequest(url);
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
        colorScheme: Theme.of(Get.context!).colorScheme,
        animeId: anime.id,
        episodeId: anime.episodes[index]['id'],
        anime: anime,
      ),
    );

    widget.controller.updateProgress();
    widget.resumeController.updateIndex();
  }

  void trackProgress() {
    var animeModel = fetchAnimeModel(anime);
    animeModel.lastSeenDate = DateTime.now();
    animeModel.lastSeenEpisodeIndex = index;

    Get.find<ObjectBox>().store.box<AnimeModel>().put(animeModel);
    widget.resumeController.updateIndex();
  }

  void handleClick() async {
    if (widget.resume) {
      index = widget.resumeController.index.value % (anime.episodes.length);
    }

    trackProgress();

    redirected = false;
    initWebView();
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
