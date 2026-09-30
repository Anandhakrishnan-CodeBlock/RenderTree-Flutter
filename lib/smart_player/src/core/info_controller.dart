import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../smart_import.dart';

class InfoController extends InfoControls {
  InfoController._internal();

  static final InfoController _instance = InfoController._internal();

  factory InfoController() {
    return _instance;
  }

  final VideoControls videoControl = VideoController();

  Map<Key, SmartVideoInfo> _videos = <Key, SmartVideoInfo>{};
  Key? _selectedKey;

  @override
  Key? get selectedKey => _selectedKey;

  @override
  Map<Key, SmartVideoInfo> get videos => _videos;

  @override
  set setVideos(Map<Key, SmartVideoInfo> videos) {
    _videos = videos;
  }

  @override
  void addInfo({required SmartVideoInfo info, required Key key}) {
    _videos[key] = info;
    SmartLogger.added(key, videos);
  }

  Timer? _refreshTimer;
  bool _isThrottling = false;
  Duration refreshRate = Duration(milliseconds: 300);

  @override
  void setInfo({
    required Key key,
    required OnLoading onLoading,
    required OnVideoReady onReady,
    required OnVideoError onError,
  }) {
    if (_isThrottling) return;
    if (_selectedKey == key) return;
    if (!_videos.containsKey(key)) return;

    videoControl.captureOutgoingPosition(
      previousKey: selectedKey,
      videos: videos,
    );

    _selectedKey = key;
    _startThrottleTimer();
    onLoading(key: _selectedKey!);
    SmartLogger.currentValue(_selectedKey!, videos);

    videoControl.pauseVideo();
    videoControl.loadVideo(
      selectedKey: key,
      videos: videos,
      onReady: ({required Key key, required VideoPlayerController controller}) {
        onReady(key: key, controller: controller);
      },
      onError: ({required Key key, required dynamic error}) {
        onError(key: key, error: error);
      },
    );
  }

  void _startThrottleTimer() {
    _isThrottling = true;
    _refreshTimer?.cancel();
    _refreshTimer = Timer(refreshRate, () {
      _isThrottling = false;
    });
  }

  @override
  void clearInfo({required Key key}) {
    if (_videos.containsKey(key)) {
      _videos.remove(key);
      if (_selectedKey == key) {
        _selectedKey = null;
      }
      SmartLogger.cleared(key, videos);
    }
  }

  @override
  void clearAll() {
    _videos.forEach((key, value) {
      SmartLogger.cleared(key, videos);
    });
    _videos.clear();
    _selectedKey = null;
  }

  @override
  void saveLastWatchedVideo() {
    if (videoControl.isPlaying()) {
      final info = _videos[selectedKey];
      if (info != null) {
        info.isLastWatched = true;
      }
    }
  }

  @override
  void playLastWatchedVideo({required Function startDrawing}) {
    videos.forEach((key, value) {
      if (value.isLastWatched) {
        startDrawing(value.key);
        value.isLastWatched = false;
      }
    });
  }

  @override
  void pauseVideo() {
    videoControl.pauseVideo();
  }

  @override
  void stopVideo() {
    videoControl.stopVideo();
  }
}
