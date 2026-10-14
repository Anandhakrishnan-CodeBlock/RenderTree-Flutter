import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../smart_import.dart';

class SmartVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String debugLabelText;
  final String? thumbnailUrl;
  final double height;
  final double width;
  final PlayMode playMode;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final bool? showProgressBar;
  final bool? showProgressDuration;

  const SmartVideoPlayerWidget({
    required Key key,
    required this.videoUrl,
    required this.debugLabelText,
    this.thumbnailUrl,
    required this.height,
    required this.width,
    this.playMode = PlayMode.auto,
    this.lastWatchedStatus = LastWatchedState.forgot,
    this.looping = false,
    this.isAsset,
    this.seekBarColor = Colors.redAccent,
    this.showProgressBar = false,
    this.showProgressDuration = false
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartVideoPlayerWidgetState();
}

class _SmartVideoPlayerWidgetState extends State<SmartVideoPlayerWidget> {
  final smartManager = SmartManager();
  late SmartVideoInfo smartVideoInfo;
  late final Stream<PlayerEvent> _videoStream;
  bool _activationScheduled = false;

  PlayerVariant variant = PlayerVariant.detail;
  @override
  void initState() {
    smartVideoInfo = SmartVideoInfo(
      key: widget.key!,
      videoUrl: widget.videoUrl,
      debugLabelText: widget.debugLabelText,
      thumbnailUrl: widget.thumbnailUrl,
      playMode: widget.playMode,
      lastWatchedState: widget.lastWatchedStatus,
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
    return SmartVideoInfoWidget(
      key: smartVideoInfo.key,
      onPaint: (activateOnPaint) {
        if (activateOnPaint &&
            smartManager.selectedKey != widget.key &&
            !_activationScheduled) {
          _activationScheduled = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _activationScheduled = false;
            smartManager.startDrawing(key: widget.key!);
          });
        }
      },
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
                    playMode: widget.playMode,
                    variant: variant,
                    seekBarColor: widget.seekBarColor,
                    showProgressBar: widget.showProgressBar ?? false,
                    showProgressDuration: widget.showProgressDuration ?? false,
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
