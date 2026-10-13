import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/widgets/smart_video_player_grid_widget.dart';
import 'smart_import.dart';

class SmartGridPlayer extends StatelessWidget {
  final String videoUrl;
  final String debugLabelText;
  final String thumbnailUrl;
  final double height;
  final double width;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final VoidCallback onClickGridItem;
  final Function? onError;

  const SmartGridPlayer({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.height,
    required this.width,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.looping = false,
    this.isAsset,
    this.seekBarColor = Colors.redAccent,
    required this.onClickGridItem,
    this.onError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerGridWidget(
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
      onError: onError,
    );
  }
}
