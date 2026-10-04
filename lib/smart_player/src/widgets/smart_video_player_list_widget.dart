import 'dart:async';
import 'package:flutter/material.dart';

import '../../smart_import.dart';

class SmartVideoPlayerListWidget extends StatefulWidget {
  final String videoUrl;
  final String debugLabelText;
  final String thumbnailUrl;
  final double height;
  final double width;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final VoidCallback onClickListItem;

  const SmartVideoPlayerListWidget({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.height,
    required this.width,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.looping = false,
    this.isAsset,
    this.seekBarColor = Colors.redAccent,
    required this.onClickListItem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartVideoPlayerListWidgetState();
}

class _SmartVideoPlayerListWidgetState extends State<SmartVideoPlayerListWidget> {

  final smartManager = SmartManager();
  late SmartVideoInfo smartVideoInfo;
  late final Stream<PlayerEvent> _videoStream;

  PlayerVariant variant = PlayerVariant.list;
  PlayMode playMode = PlayMode.auto;

  @override
  void initState() {
    smartVideoInfo = SmartVideoInfo(
      key: widget.key!,
      videoUrl: widget.videoUrl,
      debugLabelText: widget.debugLabelText,
      thumbnailUrl: widget.thumbnailUrl,
      playMode: playMode,
      lastWatchedStatus: widget.lastWatchedStatus,
      isAsset: widget.isAsset,
      looping: widget.looping,
    );
    _videoStream = smartManager.selectedVideo;

    smartManager.onInit(info: smartVideoInfo, key: widget.key!);
    super.initState();
  }

  @override
  void dispose() {
    smartManager.onDispose(key: widget.key!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onClickListItem,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: StreamBuilder<PlayerEvent>(
          stream: _videoStream,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<PlayerEvent> snapshot) {
            final event = snapshot.data;
            final bool isMine = event?.key == widget.key;
            Widget content;
            if (!isMine) {
              content = LoadingThumbnailFace(
                width: widget.width,
                height: widget.height,
                thumbnailUrl: widget.thumbnailUrl,
              );
            } else {
              switch (event!.status) {
                case PlayerEventStatus.loading:
                  content = LoadingThumbnailFace(
                    width: widget.width,
                    height: widget.height,
                    thumbnailUrl: widget.thumbnailUrl,
                  );
                  break;
                case PlayerEventStatus.failed:
                  content = const ErrorFace(text: 'Failed to load video');
                  break;
                case PlayerEventStatus.ready:
                  content = VideoFace(
                    controller: event.controller!,
                    playMode: playMode,
                    variant: variant,
                    seekBarColor: widget.seekBarColor
                  );
                  break;
              }
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: content,
            );
          },
        ),
      ),
    );
  }
}
