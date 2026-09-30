import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../smart_player.dart';

class SmartManager extends NavigationControls{
  SmartManager._internal();

  static final SmartManager _instance = SmartManager._internal();

  factory SmartManager() {
    return _instance;
  }

  final StreamController<PlayerEvent> _selectedVideo =
      StreamController<PlayerEvent>.broadcast();

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

  final smartStack = SmartStack();
  final InfoControls infoControls = InfoController();
  final ListControls listControls = ListController();

  Key? get selectedKey => infoControls.selectedKey;

  void onInit({required SmartVideoInfo info, required Key key}) {
    infoControls.addInfo(info: info, key: key);
  }

  void startDrawing({required Key key}) {
    infoControls.setInfo(
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
    listControls.reportVisibility(
        key: key,
        score: score,
        duration: duration,
        evaluateFocusWinner: () {
          listControls.evaluateFocusWinner(
              selectedKey: selectedKey,
              onWinner: ({required Key key}) {
                startDrawing(key: key);
              }
          );
        }
    );
  }

  void onDispose({required Key key}) {
    infoControls.clearInfo(key: key);
    listControls.clearVisibility(
        key: key,
        evaluateFocusWinner: () {
          listControls.evaluateFocusWinner(
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
    infoControls.clearAll();
    listControls.clearList();
    Map<Key, SmartVideoInfo> videos = smartStack.top();
    if (videos.isNotEmpty) {
      infoControls.setVideos = videos;
      infoControls.playLastWatchedVideo(startDrawing: (key){
        startDrawing(key: key);
      });
    } else {
      infoControls.stopVideo();
    }
  }

  @override
  void didPush() {
    Map<Key, SmartVideoInfo> videos = infoControls.videos;
    if (videos.isNotEmpty) {
      infoControls.saveLastWatchedVideo();
      infoControls.stopVideo();
      smartStack.push(videos);
      infoControls.clearAll();
      listControls.clearList();
    }
  }
}
