import 'package:flutter/material.dart';
import 'smart_import.dart';

class SmartPlayer extends StatelessWidget {
  final double height;
  final double width;
  final String debugLabelText;
  final String? thumbnailUrl;
  final String videoUrl;
  final bool? isAsset;
  final PlayMode? playMode;
  final LastWatchedState? lastWatchedState;
  final bool? looping;
  final Function? onVideoError;
  final Function? onImageError;
  final BorderRadiusGeometry? borderRadius;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;
  final LoadingIndicationConfig? loadingIndicationConfig;

  const SmartPlayer({
    required Key key,
    required this.height,
    required this.width,
    required this.debugLabelText,
    this.thumbnailUrl,
    required this.videoUrl,
    this.isAsset,
    this.playMode,
    this.lastWatchedState,
    this.looping,
    this.onVideoError,
    this.onImageError,
    this.borderRadius,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig,
    this.loadingIndicationConfig
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerWidget(
      key: key!,
      height: height,
      width: width,
      debugLabelText: debugLabelText,
      thumbnailUrl: thumbnailUrl,
      videoUrl: videoUrl,
      isAsset: isAsset,
      lastWatchedState: lastWatchedState,
      playMode: playMode,
      looping: looping,
      onVideoError: onVideoError,
      onImageError: onImageError,
      borderRadius: borderRadius,
      muteConfig: muteConfig,
      durationConfig: durationConfig,
      seekBarConfig: seekBarConfig,
      videoConfig: videoConfig,
      loadingIndicationConfig: loadingIndicationConfig
    );
  }
}
