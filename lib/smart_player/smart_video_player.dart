import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'smart_player.dart';

class SmartVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final String debugLabelText;
  final String? thumbnailUrl;
  final double height;
  final double width;
  final PlayMode playMode;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final PlayerVariant variant;
  final Color seekBarColor;

  const SmartVideoPlayer({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    this.thumbnailUrl,
    required this.height,
    required this.width,
    this.playMode = PlayMode.auto,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.looping = false,
    this.isAsset,
    required this.variant,
    this.seekBarColor = Colors.redAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerWidget(
      key: key!,
      videoUrl: videoUrl,
      debugLabelText: debugLabelText,
      thumbnailUrl: thumbnailUrl,
      height: height,
      width: width,
      lastWatchedStatus: lastWatchedStatus,
      playMode: playMode,
      isAsset: isAsset,
      looping: looping,
      variant: variant,
      seekBarColor: seekBarColor,
    );
  }
}
