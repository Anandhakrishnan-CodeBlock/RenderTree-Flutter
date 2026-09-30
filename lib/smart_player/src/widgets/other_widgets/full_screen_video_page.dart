import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  final Color seekBarColor;

  const FullScreenVideoPage({
    super.key,
    required this.controller,
    required this.seekBarColor,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _scheduleAutoHide();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _scheduleAutoHide() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _controlsVisible = false);
    });
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible && widget.controller.value.isPlaying) {
      _scheduleAutoHide();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      _hideControlsTimer?.cancel();
      if (!_controlsVisible) setState(() => _controlsVisible = true);
    } else {
      widget.controller.play();
      _scheduleAutoHide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(controller),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggleControls,
                    child: AnimatedOpacity(
                      opacity: _controlsVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: IgnorePointer(
                        ignoring: !_controlsVisible,
                        child: Container(
                          padding: EdgeInsets.only(right: 8, top: 8, left: 8),
                          color: Colors.black26,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: MuteToggleButton(
                                  controller: controller,
                                ),
                              ),
                              const Spacer(),
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: controller,
                                builder: (context, value, _) {
                                  return IconButton(
                                    iconSize: 64,
                                    icon: Icon(
                                      value.isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_fill,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayPause,
                                  );
                                },
                              ),
                              const Spacer(),
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: controller,
                                builder: (context, value, _) {
                                  return Column(
                                    crossAxisAlignment: .start,
                                    mainAxisSize: .min,
                                    children: [
                                      DurationBadge(
                                        position: value.position,
                                        duration: value.duration,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SeekBar(
                                              controller: controller,
                                              color: widget.seekBarColor,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          IconButton(
                                            padding: EdgeInsets.all(4.0),
                                            icon: const Icon(
                                              Icons.fullscreen_exit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
