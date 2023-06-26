import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/ui/widgets/details_content.dart';
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
import 'package:dart_ipify/dart_ipify.dart';

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
  late WebViewPlusController theController;

  late AnimeClass anime;
  late int index;

  Widget? fantasticWidget;
  InternalAPI internalAPI = Get.find<InternalAPI>();

  @override
  void initState() {
    anime = widget.anime;
    index = widget.index ?? -1;

    super.initState();
  }

  void initWebView() async {
    bool redirected = false;

    fantasticWidget = SizedBox(
      height: widget.height,
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
            if (!redirected) {
              redirected = true;
              String link = await theController.webViewController
                  .runJavascriptReturningResult(
                "document.getElementsByTagName(\"iframe\")[0].src",
              );

              if (link == "null") {
                setError(true);
              } else {
                theController.loadUrl(link.replaceAll("\"", ""));
              }
              return;
            }

            String link = await theController.webViewController
                .runJavascriptReturningResult(
              """function getLink() {
  const downloadIp = "${await Ipify.ipv4()}";
  const tokenDownload = generateToken(2, downloadIp, "Yc8U6r8KjAKAepEA");
  const downloadUrl =
    "https://au-d1-0" +
    window.videoMetadata.proxy_download +
    ".scws-content.net/download/" +
    window.videoMetadata.storage_download.number +
    "/" +
    window.videoMetadata.folder_id +
    "/" +
    window.videoMetadata.quality +
    "p.mp4" +
    "?token=" +
    tokenDownload +
    "&filename=" +
    window.videoMetadata.name.replace("&", ".");
  return downloadUrl;
}

function generateToken(hours, client_ip, secret) {
  var expires = new Date(Date.now() + 1000 * 60 * 60 * hours).getTime();
  expires = String(Math.round(expires / 1000));
  var input = expires + client_ip + " " + secret;
  var binaryHash = CryptoJS.MD5(input);
  var base64Value = binaryHash.toString(CryptoJS.enc.Base64);
  return (
    base64Value.replace(/=/g, "").replace(/\\+/g, "-").replace(/\\//g, "_") +
    "&expires=" +
    expires
  );
}

getLink();
""",
            );

            link = link.replaceAll("\"", "");
            if (link == "null" || !await isLinkOk(link)) {
              setError(true);
            } else {
              openPlayer(link);
            }

            setLoading(false);
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
