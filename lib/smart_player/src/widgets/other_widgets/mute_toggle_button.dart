import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

final class MuteToggleButton extends StatelessWidget {
  final VideoPlayerController controller;
  final MuteConfig? muteConfig;

  const MuteToggleButton({
    super.key,
    required this.controller,
    this.muteConfig = const MuteConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final config = muteConfig ?? const MuteConfig();
    if (!config.showMuteIcon) {
      return const SizedBox.shrink();
    }
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final bool muted = value.volume == 0;
        return Container(
          width: config.backgroundSize,
          height: config.backgroundSize,
          decoration: BoxDecoration(
            shape: config.backgroundShape,
            color: config.backgroundColor,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: muted ? config.muteIcon : config.unMuteIcon,
            onPressed: () => controller.setVolume(muted ? 1.0 : 0.0),
          ),
        );
      },
    );
  }
}