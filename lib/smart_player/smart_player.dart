import 'package:flutter/material.dart';
import 'smart_import.dart';

class SmartPlayer extends StatelessWidget {
  final String videoUrl;
  final String debugLabelText;
  final String? thumbnailUrl;
  final double height;
  final double width;
  final PlayMode playMode;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final bool? showProgressBar;
  final bool? showProgressDuration;

  const SmartPlayer({
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
    this.seekBarColor = Colors.redAccent,
    this.showProgressBar = false,
    this.showProgressDuration = false
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
      seekBarColor: seekBarColor,
      showProgressBar: showProgressBar,
      showProgressDuration: showProgressDuration,
    );
  }
}
