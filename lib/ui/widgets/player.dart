import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/objectbox.g.dart';
import 'package:baka_animestream/services/internal_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final ColorScheme colorScheme;

  final int animeId;
  final int episodeId;

  const PlayerPage({
    Key? key,
    required this.url,
    required this.colorScheme,
    required this.animeId,
    required this.episodeId,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  late MeeduPlayerController _meeduPlayerController;
  late AnimeModel animeModel;

  Box objBox = Get.find<ObjectBox>().store.box<AnimeModel>();

  int getSeconds() {
    var currTime = animeModel.episodes[widget.episodeId.toString()];
    if (currTime == null) return 0;
    return currTime[0];
  }

  @override
  void initState() {
    animeModel = objBox.get(widget.animeId);
    animeModel.decodeStr();

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
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _meeduPlayerController.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    super.dispose();
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
