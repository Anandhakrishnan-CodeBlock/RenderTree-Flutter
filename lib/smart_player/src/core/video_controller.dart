import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../smart_import.dart';

class VideoController extends VideoControls {
  VideoController._internal();

  static final VideoController _instance = VideoController._internal();

  factory VideoController() {
    return _instance;
  }

  final PlayerControls _playerController = PlayerController();
  final StreamController<PlayerEvent> _selectedVideo =
  StreamController<PlayerEvent>.broadcast();

  @override
  Stream<PlayerEvent> get selectedVideo => _selectedVideo.stream;

  @override
  bool isPlaying() => _playerController.isPlaying();

  @override
  void captureOutgoingPosition({
    required Key? previousKey,
    required Map<Key, SmartVideoInfo> videos,
  }) {
    if (previousKey == null) return;

    final Key preKey = previousKey;
    final previousInfo = videos[preKey];
    final controller = _playerController.getController();
    if (previousInfo != null &&
        controller != null &&
        controller.value.isInitialized) {
      previousInfo.savedPosition = controller.value.position;
    }
  }

  int _currentLoadId = 0;

  @override
  Future<void> loadVideo({
    required Key? selectedKey,
    required Map<Key, SmartVideoInfo> videos,
    required OnVideoReady onReady,
    required OnVideoError onError,
  }) async {
    if (selectedKey == null) return;

    final info = videos[selectedKey];
    if (info == null) return;

    final loadId = ++_currentLoadId;

    try {
      // 1. Initialize video player
      await _playerController.initialize(
        info.videoUrl,
        info.isAsset,
        info.looping,
      );

      // Check if this request is still active
      if (loadId != _currentLoadId) return;

      // 2. Seek to saved position if needed
      if (info.lastWatchedStatus == LastWatchedState.save &&
          info.savedPosition > Duration.zero) {
        await _playerController.seekTo(info.savedPosition);
      }

      if (loadId != _currentLoadId) return;

      // 3. Auto play if needed
      if (info.playMode == PlayMode.auto) {
        await _playerController.play();
      }

      if (loadId != _currentLoadId) return;

      // 4. Emit ready event
      final controller = _playerController.getController();
      if (controller != null) {
        SmartLogger.paint(selectedKey, videos);
        onReady(key: selectedKey, controller: controller);
      }
    } catch (error) {
      if (loadId == _currentLoadId) {
        onError(key: selectedKey, error: error);
      }
    }
  }

  @override
  Future<void> pauseVideo() async {
    if (isPlaying()) {
      await _playerController.pause();
    }
  }

  @override
  Future<void> stopVideo() async {
    if (isPlaying())  {
      await _playerController.stop();
    }
  }
}