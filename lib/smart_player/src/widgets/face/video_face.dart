import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

class VideoFace extends StatefulWidget {
  final VideoPlayerController controller;
  final PlayMode playMode;
  final PlayerVariant variant;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;

  const VideoFace({
    super.key,
    required this.controller,
    required this.playMode,
    required this.variant,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig = const VideoConfig()
  });

  @override
  State<StatefulWidget> createState() => VideoFaceState();
}

class VideoFaceState extends State<VideoFace> {
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;
  Timer? _debounceTimer;
  final Duration timeoutDuration = const Duration(seconds: 15);

  late double width;
  late double height;

  @override
  void initState() {
    width = widget.controller.value.size.width;
    height = widget.controller.value.size.height;
    _controlsVisible = widget.playMode == PlayMode.manual ? true : false;
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.videoConfig ?? const VideoConfig();
    return Container(
      color: config.backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: width,
            height: height,
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    child!,
                    if (value.isBuffering)
                       CircularProgressIndicator(
                          color: config.bufferingIndicatorColor,
                          strokeWidth: config.bufferingIndicatorWidth,
                      ),
                  ],
                );
              },
              child: PaintListenerWidget(
                onPaintStateChanged: (isPainting) {
                  if (!isPainting) {
                    _resetTimer(widget.controller);
                  }
                },
                child: AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: VideoPlayer(widget.controller)),
              ),
            ),
          ),
          if (widget.variant != PlayerVariant.detail)
            ListOverlay(
              videoController: widget.controller,
              controlsVisible: _controlsVisible,
              muteConfig: widget.muteConfig,
              durationConfig: widget.durationConfig,
              seekBarConfig: widget.seekBarConfig,
              videoConfig: config,
            )
          else
            DetailOverlay(
              videoController: widget.controller,
              controlsVisible: _controlsVisible,
              muteConfig: widget.muteConfig,
              durationConfig: widget.durationConfig,
              seekBarConfig: widget.seekBarConfig,
              videoConfig: config,
              openFullscreen: () {
                _openFullscreen(widget.controller);
              },
              toggleControls: () {
                _toggleControls();
              },
              togglePlayPause: () {
                _togglePlayPause(widget.controller);
              },
            ),
        ],
      ),
    );
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) {
      _scheduleAutoHide();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _togglePlayPause(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      _hideControlsTimer?.cancel();
      if (!_controlsVisible) setState(() => _controlsVisible = true);
    } else {
      controller.play();
      _scheduleAutoHide();
    }
  }

  void _scheduleAutoHide() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _controlsVisible = false);
    });
  }

  void _openFullscreen(VideoPlayerController controller) {
    _hideControlsTimer?.cancel();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenVideoPage(
          controller: controller,
          muteConfig: widget.muteConfig,
          durationConfig: widget.durationConfig,
          seekBarConfig: widget.seekBarConfig,
          videoConfig: widget.videoConfig,
        ),
      ),
    );
  }

  void _resetTimer(VideoPlayerController controller) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(timeoutDuration, () {
      controller.pause();
      debugPrint("Stop Video !");
    });
  }
}
