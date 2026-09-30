import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/widgets/smart_video_player_list_widget.dart';
import 'smart_import.dart';

class SmartListPlayer extends StatelessWidget {
  final String videoUrl;
  final String debugLabelText;
  final String thumbnailUrl;
  final double height;
  final double width;
  final PlayMode playMode;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final VoidCallback onClickListItem;

  const SmartListPlayer({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.height,
    required this.width,
    this.playMode = PlayMode.auto,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.looping = false,
    this.isAsset,
    this.seekBarColor = Colors.redAccent,
    required this.onClickListItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerListWidget(
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
      onClickListItem: onClickListItem,
    );
  }
}
