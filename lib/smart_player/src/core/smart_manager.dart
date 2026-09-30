import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../smart_import.dart';

class SmartManager extends NavigationControls{
  SmartManager._internal();

  static final SmartManager _instance = SmartManager._internal();

  factory SmartManager() {
    return _instance;
  }

  final StreamController<PlayerEvent> _selectedVideo = StreamController<PlayerEvent>.broadcast();

  Stream<PlayerEvent> get selectedVideo => _selectedVideo.stream;

  void loadingEvent({required Key key}) {
    _selectedVideo.add(PlayerEvent.loading(key: key));
  }

  void readyEvent({
    required Key key,
    required VideoPlayerController controller}) {
    _selectedVideo.add(PlayerEvent.ready(key: key, controller: controller));
  }

  void failedEvent({
    required Key key,
    required Object error}) {
    _selectedVideo.add(PlayerEvent.failed(key: key, error: error));
  }

  final _smartStack = SmartStack();
  final InfoControls _infoControls = InfoController();
  final ListControls _listControls = ListController();

  Key? get selectedKey => _infoControls.selectedKey;

  void onInit({required SmartVideoInfo info, required Key key}) {
    _infoControls.addInfo(info: info, key: key);
  }

  void startDrawing({required Key key}) {
    _infoControls.setInfo(
      key: key,
      onLoading: ({required Key key}) {
        loadingEvent(key: key);
      },
      onReady: ({required Key key,required VideoPlayerController controller}) {
        readyEvent(key: key, controller: controller);
      },
      onError: ({required Key key,required dynamic error}) {
        failedEvent(key: key, error: error);
      },
    );
  }

  void reportVisibility({
    required Key key,
    required double score,
    Duration? duration,
  }) {
    _listControls.reportVisibility(
        key: key,
        score: score,
        duration: duration,
        evaluateFocusWinner: () {
          _listControls.evaluateFocusWinner(
              selectedKey: selectedKey,
              onWinner: ({required Key key}) {
                startDrawing(key: key);
              }
          );
        }
    );
  }

  void onDispose({required Key key}) {
    _infoControls.clearInfo(key: key);
    _listControls.clearVisibility(
        key: key,
        evaluateFocusWinner: () {
          _listControls.evaluateFocusWinner(
              selectedKey: selectedKey,
              onWinner: ({required Key key}) {
                startDrawing(key: key);
              }
          );
        }
    );
  }

  @override
  void didPop() {
    _infoControls.clearAll();
    _listControls.clearList();
    Map<Key, SmartVideoInfo> videos = _smartStack.top();
    if (videos.isNotEmpty) {
      _infoControls.setVideos = videos;
      _infoControls.playLastWatchedVideo(startDrawing: (key){
        startDrawing(key: key);
      });
    } else {
      _infoControls.stopVideo();
    }
  }

  @override
  void didPush() {
    Map<Key, SmartVideoInfo> videos = _infoControls.videos;
    if (videos.isNotEmpty) {
      _infoControls.saveLastWatchedVideo();
      _infoControls.stopVideo();
      _smartStack.push(videos);
      _infoControls.clearAll();
      _listControls.clearList();
    }
  }
}
