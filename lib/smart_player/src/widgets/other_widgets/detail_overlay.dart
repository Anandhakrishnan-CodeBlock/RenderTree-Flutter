import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_player.dart';

class DetailOverlay extends StatelessWidget {
  final VideoPlayerController videoController;
  final bool controlsVisible;
  final Color seekBarColor;
  final VoidCallback toggleControls;
  final VoidCallback openFullscreen;
  final VoidCallback togglePlayPause;

  const DetailOverlay({
    super.key,
    required this.videoController,
    required this.controlsVisible,
    required this.seekBarColor,
    required this.toggleControls,
    required this.openFullscreen,
    required this.togglePlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: toggleControls,
        child: AnimatedOpacity(
          opacity: controlsVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !controlsVisible,
            child: Container(
              color: Colors.black26,
              padding: EdgeInsets.only(right: 8, top: 8, left: 8),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  Align(
                    alignment: AlignmentGeometry.topRight,
                      child: MuteToggleButton(controller: videoController)
                  ),
                  const Spacer(),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoController,
                    builder: (context, value, _) {
                      return IconButton(
                        iconSize: 56,
                        icon: Icon(
                          value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        onPressed: () => togglePlayPause(),
                      );
                    },
                  ),
                  const Spacer(),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoController,
                    builder: (context, value, _) {
                      return Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Row(
                            children: [
                              DurationBadge(
                                position: value.position,
                                duration: value.duration,
                              ),
                              Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                ),
                                onPressed: () => openFullscreen(),
                              ),
                            ],
                          ),
                          SeekBar(
                            controller: videoController,
                            color: seekBarColor,
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
    );
  }
}
