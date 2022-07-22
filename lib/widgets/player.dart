import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  const PlayerPage({Key? key, required this.url}) : super(key: key);

  @override
  State<PlayerPage> createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  late BetterPlayerController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late List colors = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.addObserver(this);

    mediaPlayerControllerSetUp();
    _controller.setOverriddenFit(BoxFit.contain);
  }

  final indicator = const CircularProgressIndicator();

  void mediaPlayerControllerSetUp() {
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fullScreenByDefault: true,
        translations: [
          BetterPlayerTranslations(
            languageCode: "it",
            generalDefaultError: "Il video non può essere riprodoto",
            generalNone: "Nessuno",
            generalDefault: "Default",
            generalRetry: "Riprova",
            controlsLive: "LIVE",
            playlistLoadingNextVideo: "Caricando il video successivo",
            controlsNextVideoIn: "Prossimo video in",
            overflowMenuPlaybackSpeed: "Velocità riproduzione",
            overflowMenuSubtitles: "Sottotitoli",
            overflowMenuQuality: "Qualitá",
            overflowMenuAudioTracks: "Audio",
            qualityAuto: "Auto",
          )
        ],
        autoDetectFullscreenAspectRatio: true,
        fit: BoxFit.fitHeight,
        aspectRatio: 16 / 9,
        handleLifecycle: false,
        autoDetectFullscreenDeviceOrientation: true,
        autoPlay: true,
        allowedScreenSleep: false,
        autoDispose: true,
        fullScreenAspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          overflowModalColor: Colors.black87,
          overflowMenuIconsColor: Colors.white,
          overflowModalTextColor: Colors.white,
          playIcon: Icons.play_arrow,
          pauseIcon: Icons.pause_outlined,
          playerTheme: BetterPlayerTheme.cupertino,
          enableFullscreen: true,
          controlBarColor: const Color(0xFF0D1321).withOpacity(.75),
          loadingWidget: indicator,
          progressBarPlayedColor: const Color(0xFF060B16),
          progressBarBufferedColor: Colors.grey,
          progressBarBackgroundColor: const Color(0xFF323435),
          progressBarHandleColor: const Color(0xFF133F6E),
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 60000,
          maxBufferMs: 555000,
        ),
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          preCacheSize: 400000,
          maxCacheSize: 400000,
          maxCacheFileSize: 400000,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _controller.setControlsAlwaysVisible(true);
        break;
      case AppLifecycleState.inactive:
        _controller.pause();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.clearCache();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      backgroundColor: Colors.black,
      body: BetterPlayer(
        controller: _controller,
      ),
    );
  }
}
