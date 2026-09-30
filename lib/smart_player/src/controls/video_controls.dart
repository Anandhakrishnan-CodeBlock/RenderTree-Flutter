import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../smart_player.dart';

abstract mixin class VideoControls {

  Stream<PlayerEvent> get selectedVideo;

  bool isPlaying();

  void captureOutgoingPosition({
    required Key? previousKey,
    required Map<Key, SmartVideoInfo> videos,
  });

  void loadVideo({
    required Key? selectedKey,
    required Map<Key, SmartVideoInfo> videos,
    required OnVideoReady onReady,
    required OnVideoError onError,
  });

  Future<void> pauseVideo();

  Future<void> stopVideo();
}
