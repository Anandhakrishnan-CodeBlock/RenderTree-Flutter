import 'dart:async';

import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/enums/play_mode.dart';
import 'package:renter_tree_test/smart_player/src/enums/player_variant.dart';
import 'package:renter_tree_test/smart_player/src/render/paint_listener_widget.dart';
import 'package:renter_tree_test/smart_player/src/widgets/other_widgets/detail_overlay.dart';
import 'package:renter_tree_test/smart_player/src/widgets/other_widgets/full_screen_video_page.dart';
import 'package:renter_tree_test/smart_player/src/widgets/other_widgets/list_overlay.dart';
import 'package:video_player/video_player.dart';

class VideoFace extends StatefulWidget {
  final VideoPlayerController controller;
  final PlayMode playMode;
  final PlayerVariant variant;
  final Color seekBarColor;

  const VideoFace({
    super.key,
    required this.controller,
    required this.playMode,
    required this.variant,
    required this.seekBarColor,
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
    return Stack(
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
                    const CircularProgressIndicator(color: Colors.white),
                ],
              );
            },
            child: PaintListenerWidget(
              onPaintStateChanged: () {
                resetTimer(widget.controller);
              },
              child: VideoPlayer(widget.controller),
            ),
          ),
        ),
        if (widget.variant == PlayerVariant.list)
          ListOverlay(
            videoController: widget.controller,
            controlsVisible: _controlsVisible,
            seekBarColor: widget.seekBarColor,
            onTap: () {
              // TODO onClick
            },
          )
        else
          DetailOverlay(
            videoController: widget.controller,
            controlsVisible: _controlsVisible,
            seekBarColor: widget.seekBarColor,
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
          seekBarColor: widget.seekBarColor,
        ),
      ),
    );
  }

  void resetTimer(VideoPlayerController controller) {
    debugPrint("Painting !");
    _debounceTimer?.cancel();
    _debounceTimer = Timer(timeoutDuration, () {
      controller.pause();
      debugPrint("Stop Video !");
    });
  }
}
