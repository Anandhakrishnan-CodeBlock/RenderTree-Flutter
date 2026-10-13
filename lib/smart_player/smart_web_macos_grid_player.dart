import 'package:flutter/material.dart';
import 'smart_import.dart';

class SmartWebMacosGridPlayer extends StatelessWidget {
  final String videoUrl;
  final String debugLabelText;
  final String thumbnailUrl;
  final double height;
  final double width;
  final LastWatchedState? lastWatchedStatus;
  final bool? isAsset;
  final bool? looping;
  final Color? seekBarColor;
  final VoidCallback onClickGridItem;
  final bool? showProgressBar;
  final bool? showProgressDuration;
  final Function? onError;

  const SmartWebMacosGridPlayer({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.height,
    required this.width,
    this.lastWatchedStatus,
    this.looping,
    this.isAsset,
    this.seekBarColor,
    required this.onClickGridItem,
    this.showProgressBar,
    this.showProgressDuration,
    this.onError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerGridWebMacosWidget(
      key: key!,
      videoUrl: videoUrl,
      debugLabelText: debugLabelText,
      thumbnailUrl: thumbnailUrl,
      height: height,
      width: width,
      lastWatchedStatus: lastWatchedStatus,
      isAsset: isAsset,
      looping: looping,
      seekBarColor: seekBarColor,
      onClickGridItem: onClickGridItem,
      showProgressBar: showProgressBar,
      showProgressDuration: showProgressDuration,
      onError: onError,
    );
  }
}