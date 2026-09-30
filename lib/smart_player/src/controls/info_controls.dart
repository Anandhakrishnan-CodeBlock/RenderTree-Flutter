
import 'package:flutter/material.dart';

import '../../smart_player.dart';

abstract mixin class InfoControls {
  Key? get selectedKey;

  Map<Key, SmartVideoInfo> get videos;

  set setVideos(Map<Key, SmartVideoInfo> videos);

  void addInfo({
    required SmartVideoInfo info,
    required Key key
  });

  void setInfo({
    required Key key,
    required OnLoading onLoading,
    required OnVideoReady onReady,
    required OnVideoError onError,
  });

  void clearInfo({required Key key});

  void clearAll();

  void saveLastWatchedVideo();

  void playLastWatchedVideo({
    required Function startDrawing
  });

  void pauseVideo();

  void stopVideo();
}

