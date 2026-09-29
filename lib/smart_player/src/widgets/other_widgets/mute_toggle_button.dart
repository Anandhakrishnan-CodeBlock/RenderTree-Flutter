import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final class MuteToggleButton extends StatelessWidget {

  final VideoPlayerController controller;
  final bool compact;

  const MuteToggleButton({
    super.key,
    required this.controller,
    this.compact = false
  });

  @override
  Widget build(BuildContext context) {
    final double size = compact ? 28 : 36;
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final bool muted = value.volume == 0;
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black45,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: compact ? 16 : 20,
            icon: Icon(
              muted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () => controller.setVolume(muted ? 1.0 : 0.0),
          ),
        );
      },
    );
  }
}