import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../smart_import.dart';

class SmartVideoPlayerWidget extends StatefulWidget {
  final double height;
  final double width;
  final String debugLabelText;
  final String thumbnailUrl;
  final String videoUrl;
  final bool? isAsset;
  final PlayMode? playMode;
  final LastWatchedState? lastWatchedState;
  final bool? looping;
  final Function? onVideoError;
  final Function? onImageError;
  final BorderRadiusGeometry? borderRadius;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;

  const SmartVideoPlayerWidget({
    required Key key,
    required this.height,
    required this.width,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isAsset,
    this.playMode,
    this.lastWatchedState,
    this.looping,
    this.onVideoError,
    this.onImageError,
    this.borderRadius,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig
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
  PlayMode playMode = PlayMode.auto;
  late BorderRadiusGeometry borderRadius = widget.borderRadius ?? BorderRadiusGeometry.zero;
  late LastWatchedState lastWatchedState = widget.lastWatchedState ?? LastWatchedState.forgot;
  late bool isAsset = widget.isAsset ?? false;
  late bool looping = widget.looping ?? false;

  @override
  void initState() {
    smartVideoInfo = SmartVideoInfo(
      key: widget.key!,
      videoUrl: widget.videoUrl,
      debugLabelText: widget.debugLabelText,
      thumbnailUrl: widget.thumbnailUrl,
      playMode: playMode,
      lastWatchedState: lastWatchedState,
      isAsset: isAsset,
      looping: looping,
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
                onImageError: widget.onImageError,
              );
            } else {
              switch (event!.status) {
                case PlayerEventStatus.loading:
                  content = LoadingThumbnailFace(
                    width: widget.width,
                    height: widget.height,
                    thumbnailUrl: widget.thumbnailUrl,
                    onImageError: widget.onImageError,
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
                    muteConfig: widget.muteConfig,
                    durationConfig: widget.durationConfig,
                    seekBarConfig: widget.seekBarConfig,
                    videoConfig: widget.videoConfig,
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
