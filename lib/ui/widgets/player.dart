import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/objectbox.g.dart';
import 'package:baka_animestream/services/internal_db.dart';
import 'package:baka_animestream/ui/widgets/details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final ColorScheme colorScheme;

  final int animeId;
  final int episodeId;

  final AnimeClass anime;

  const PlayerPage({
    Key? key,
    required this.url,
    required this.colorScheme,
    required this.animeId,
    required this.episodeId,
    required this.anime,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  late MeeduPlayerController _meeduPlayerController;
  late AnimeModel animeModel;

  Box objBox = Get.find<ObjectBox>().store.box<AnimeModel>();
  int index = 0;

  int getSeconds() {
    var currTime = animeModel.episodes[widget.episodeId.toString()];
    if (currTime == null) return 0;
    return currTime[0];
  }

  @override
  void initState() {
    debugPrint("Player page");
    WidgetsBinding.instance.addObserver(this);

    animeModel = objBox.get(widget.animeId);
    animeModel.decodeStr();

    index = animeModel.lastSeenEpisodeIndex!;

    _meeduPlayerController = MeeduPlayerController(
      colorTheme: widget.colorScheme.primary,
      pipEnabled: true,
      showLogs: true,
      loadingWidget: CircularProgressIndicator(
        color: widget.colorScheme.primary,
      ),
      screenManager: const ScreenManager(
        forceLandScapeInFullscreen: true,
        orientations: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      ),
      enabledButtons: const EnabledButtons(
        fullscreen: false,
        muteAndSound: false,
        pip: true,
        playPauseAndRepeat: true,
        playBackSpeed: false,
        videoFit: true,
        rewindAndfastForward: false,
      ),
      controlsStyle: ControlsStyle.primary,
      customIcons: const CustomIcons(
        pip: Icon(Icons.picture_in_picture_alt),
        videoFit: Icon(Icons.fit_screen),
        play: Icon(Icons.play_arrow, size: 50),
        pause: Icon(Icons.pause, size: 50),
      ),
      header: Align(
        alignment: Alignment.topLeft,
        child: BackButton(
          color: widget.colorScheme.primary,
        ),
      ),
    );

    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: widget.url,
      ),
      autoplay: true,
      seekTo: Duration(seconds: getSeconds()),
    );

    _meeduPlayerController.onDataStatusChanged.listen((event) {
      if (event == DataStatus.loaded) {
        _meeduPlayerController.setFullScreen(true, context);
      }
    });

    _meeduPlayerController.onFullscreenChanged.listen((event) {
      if (event == false) {
        Get.back();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });

    trackTime();

    super.initState();
  }

  @override
  void dispose() {
    _meeduPlayerController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _meeduPlayerController.enterPip(context);
    }
  }

  void trackTime() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    var current = _meeduPlayerController.position.value;
    var duration = _meeduPlayerController.duration.value;
    // update the lastMinutage of the episode
    animeModel.episodes[widget.episodeId.toString()] = [
      current.inSeconds,
      duration.inSeconds
    ];

    int remaining = duration.inSeconds - current.inSeconds;
    if (remaining < 120 && remaining != -1 && duration.inSeconds > 0) {
      animeModel.lastSeenEpisodeIndex =
          (index + 1) % widget.anime.episodes.length;
    }

    animeModel.encodeStr();
    objBox.put(animeModel);

    debugPrint("Current: ${current.inSeconds.toString()}");

    trackTime();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MeeduVideoPlayer(
        controller: _meeduPlayerController,
      ),
    );
  }
}
