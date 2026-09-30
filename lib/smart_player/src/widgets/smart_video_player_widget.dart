import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../smart_player.dart';

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
  final PlayerVariant variant;
  final Color seekBarColor;

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
    required this.variant,
    this.seekBarColor = Colors.redAccent,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartVideoPlayerWidgetState();
}

class _SmartVideoPlayerWidgetState extends State<SmartVideoPlayerWidget> {
  final smartManager = SmartManager();
  late SmartVideoInfo smartVideoInfo;
  late final Stream<PlayerEvent> _videoStream;
  bool _activationScheduled = false;

  @override
  void initState() {
    if (widget.variant != PlayerVariant.detail) {
      final isType1 =
          widget.variant == PlayerVariant.list &&
          widget.playMode == PlayMode.auto;
      assert(isType1, 'List variant needs to be in auto mode.');
    }
    smartVideoInfo = SmartVideoInfo(
      key: widget.key!,
      videoUrl: widget.videoUrl,
      debugLabelText: widget.debugLabelText,
      thumbnailUrl: widget.thumbnailUrl,
      playMode: widget.playMode,
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
                    variant: widget.variant,
                    seekBarColor: widget.seekBarColor,
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
