import 'package:flutter/material.dart';
import 'smart_import.dart';

class SmartWebMacosGridPlayer extends StatelessWidget {
  final double height;
  final double width;
  final String debugLabelText;
  final String thumbnailUrl;
  final String videoUrl;
  final bool? isAsset;
  final LastWatchedState? lastWatchedState;
  final bool? looping;
  final bool? showProgressBar;
  final bool? showProgressDuration;
  final VoidCallback onClickGridItem;
  final Function? onError;
  final BorderRadiusGeometry? borderRadius;

  const SmartWebMacosGridPlayer({
    required Key key,
    required this.height,
    required this.width,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isAsset,
    this.lastWatchedState,
    this.looping,
    this.showProgressBar,
    this.showProgressDuration,
    required this.onClickGridItem,
    this.onError,
    this.borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerGridWebMacosWidget(
        key: key!,
        height: height,
        width: width,
        debugLabelText: debugLabelText,
        thumbnailUrl: thumbnailUrl,
        videoUrl: videoUrl,
        isAsset: isAsset,
        lastWatchedState: lastWatchedState,
        looping: looping,
        showProgressBar: showProgressBar,
        showProgressDuration: showProgressDuration,
        onClickGridItem: onClickGridItem,
        onError: onError,
        borderRadius: borderRadius
    );
  }
}