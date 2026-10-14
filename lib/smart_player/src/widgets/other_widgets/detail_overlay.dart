import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

class DetailOverlay extends StatelessWidget {
  final VideoPlayerController videoController;
  final bool controlsVisible;
  final VoidCallback toggleControls;
  final VoidCallback openFullscreen;
  final VoidCallback togglePlayPause;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;

  const DetailOverlay({
    super.key,
    required this.videoController,
    required this.controlsVisible,
    required this.toggleControls,
    required this.openFullscreen,
    required this.togglePlayPause,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig = const VideoConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final config = videoConfig ?? const VideoConfig();
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
                    child: MuteToggleButton(
                      controller: videoController,
                      muteConfig: muteConfig,
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoController,
                    builder: (context, value, _) {
                      return IconButton(
                        iconSize: 56,
                        icon: value.isPlaying
                            ? config.pauseIcon
                            : config.playIcon,
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
                                durationConfig: durationConfig,
                              ),
                              Spacer(),
                              IconButton(
                                icon: config.maximizeIcon,
                                onPressed: () => openFullscreen(),
                              ),
                            ],
                          ),
                          SeekBar(
                            controller: videoController,
                            seekBarConfig: seekBarConfig,
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
