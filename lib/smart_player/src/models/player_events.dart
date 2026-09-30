import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../smart_import.dart';

class PlayerEvent {
  final Key key;
  final PlayerEventStatus status;
  final VideoPlayerController? controller;
  final Object? error;

  const PlayerEvent.loading({required this.key})
      : status = PlayerEventStatus.loading,
        controller = null,
        error = null;

  const PlayerEvent.ready({required this.key, required this.controller})
      : status = PlayerEventStatus.ready,
        error = null;

  const PlayerEvent.failed({required this.key, required this.error})
      : status = PlayerEventStatus.failed,
        controller = null;
}