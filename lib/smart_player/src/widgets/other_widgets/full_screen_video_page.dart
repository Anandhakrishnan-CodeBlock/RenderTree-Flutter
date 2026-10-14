import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;

  const FullScreenVideoPage({
    super.key,
    required this.controller,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig = const VideoConfig()
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
    _playVideo();
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
    final config = widget.videoConfig ?? const VideoConfig();
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
                                  muteConfig: widget.muteConfig
                                ),
                              ),
                              const Spacer(),
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: controller,
                                builder: (context, value, _) {
                                  return IconButton(
                                    iconSize: 64,
                                    icon: value.isPlaying
                                        ? config.pauseIcon
                                        : config.playIcon,
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
                                        durationConfig: widget.durationConfig
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SeekBar(
                                              controller: controller,
                                              seekBarConfig: widget.seekBarConfig,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          IconButton(
                                            padding: EdgeInsets.all(4.0),
                                            icon: config.minimizeIcon,
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

  void _playVideo() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.play();
    });
  }
}
