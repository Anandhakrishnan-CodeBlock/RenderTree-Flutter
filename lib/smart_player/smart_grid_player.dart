import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/widgets/smart_video_player_grid_widget.dart';
import 'smart_import.dart';

class SmartGridPlayer extends StatelessWidget {
  final double height;
  final double width;
  final String debugLabelText;
  final String thumbnailUrl;
  final String videoUrl;
  final bool? isAsset;
  final LastWatchedState? lastWatchedState;
  final bool? looping;
  final VoidCallback onClickGridItem;
  final Function? onVideoError;
  final Function? onImageError;
  final BorderRadiusGeometry? borderRadius;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;


  const SmartGridPlayer({
    required Key key,
    required this.height,
    required this.width,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isAsset,
    this.lastWatchedState,
    this.looping,
    required this.onClickGridItem,
    this.onVideoError,
    this.onImageError,
    this.borderRadius,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartVideoPlayerGridWidget(
      key: key!,
      height: height,
      width: width,
      debugLabelText: debugLabelText,
      thumbnailUrl: thumbnailUrl,
      videoUrl: videoUrl,
      isAsset: isAsset,
      lastWatchedState: lastWatchedState,
      looping: looping,
      onClickGridItem: onClickGridItem,
      onVideoError: onVideoError,
      onImageError: onImageError,
      borderRadius: borderRadius,
      muteConfig: muteConfig,
      durationConfig: durationConfig,
      seekBarConfig: seekBarConfig,
      videoConfig: videoConfig
    );
  }
}
