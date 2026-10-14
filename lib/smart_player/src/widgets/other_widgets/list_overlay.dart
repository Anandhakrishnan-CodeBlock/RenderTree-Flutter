import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

class ListOverlay extends StatelessWidget {
  final VideoPlayerController videoController;
  final bool controlsVisible;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;

  const ListOverlay({
    super.key,
    required this.videoController,
    required this.controlsVisible,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig = const VideoConfig()
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        padding: EdgeInsets.only(right: 8, top: 8),
        child: Column(
          crossAxisAlignment: .end,
          children: [
            MuteToggleButton(
                controller: videoController,
                muteConfig: muteConfig,
            ),
            const Spacer(),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: videoController,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: .end,
                  mainAxisSize: .min,
                  children: [
                    DurationBadge(
                      position: value.position,
                      duration: value.duration,
                      durationConfig: durationConfig,
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
    );
  }
}
