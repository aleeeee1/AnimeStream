import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final ColorScheme colorScheme;
  const PlayerPage({Key? key, required this.url, required this.colorScheme})
      : super(key: key);

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
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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
        expandToFill: true,
        autoDetectFullscreenAspectRatio: true,
        fit: BoxFit.fitHeight,
        handleLifecycle: false,
        autoDetectFullscreenDeviceOrientation: true,
        autoPlay: true,
        allowedScreenSleep: false,
        autoDispose: true,
        fullScreenAspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableQualities: false,
          enableSubtitles: false,
          enableAudioTracks: false,
          enablePip: true,
          overflowModalColor: widget.colorScheme.secondaryContainer,
          overflowMenuIconsColor: widget.colorScheme.onSecondaryContainer,
          overflowModalTextColor: widget.colorScheme.onSecondaryContainer,
          iconsColor: widget.colorScheme.primary,
          playIcon: Icons.play_arrow,
          pauseIcon: Icons.pause_outlined,
          playerTheme: BetterPlayerTheme.cupertino,
          enableFullscreen: true,
          controlBarColor: widget.colorScheme.background.withOpacity(.60),
          loadingWidget: indicator,
          progressBarPlayedColor: widget.colorScheme.primary,
          progressBarBufferedColor:
              widget.colorScheme.secondary.withAlpha(0xAF),
          progressBarBackgroundColor:
              widget.colorScheme.secondaryContainer.withAlpha(0xFF),
          progressBarHandleColor: widget.colorScheme.primary,
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
