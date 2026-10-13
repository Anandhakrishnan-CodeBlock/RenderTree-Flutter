import 'dart:async';
import 'package:flutter/material.dart';

import '../../smart_import.dart';

class SmartVideoPlayerGridWidget extends StatefulWidget {
  final String videoUrl;
  final String debugLabelText;
  final String thumbnailUrl;
  final double height;
  final double width;
  final LastWatchedState lastWatchedStatus;
  final bool? isAsset;
  final bool looping;
  final Color seekBarColor;
  final VoidCallback onClickGridItem;
  final bool? showProgressBar;
  final bool? showProgressDuration;
  final Function? onError;

  const SmartVideoPlayerGridWidget({
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
    required this.onClickGridItem,
    this.showProgressBar = false,
    this.showProgressDuration = false,
    this.onError
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartVideoPlayerGridWidgetState();
}

class _SmartVideoPlayerGridWidgetState extends State<SmartVideoPlayerGridWidget> {

  final smartManager = SmartManager();
  late SmartVideoInfo smartVideoInfo;
  late final Stream<PlayerEvent> _videoStream;

  PlayerVariant variant = PlayerVariant.grid;
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
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder<PlayerEvent>(
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
                    widget.onError?.call(event.error);
                    break;
                  case PlayerEventStatus.ready:
                    content = VideoFace(
                      controller: event.controller!,
                      playMode: playMode,
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

          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onClickGridItem();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
