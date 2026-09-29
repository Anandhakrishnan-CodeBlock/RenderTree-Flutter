import 'package:flutter/foundation.dart';
import '../../smart_player.dart';

class SmartVideoInfo {
  final Key key;
  final String videoUrl;
  final String debugLabelText;
  final String? thumbnailUrl;
  final PlayMode playMode;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  Duration savedPosition = Duration.zero;
  bool isLastWatched = false;

  SmartVideoInfo({
    required this.key,
    required this.videoUrl,
    required this.debugLabelText,
    this.thumbnailUrl,
    this.playMode = PlayMode.auto,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.isAsset,
    this.looping = false,
    this.savedPosition = Duration.zero,
    this.isLastWatched = false,
  });
}
