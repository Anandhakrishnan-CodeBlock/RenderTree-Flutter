import 'dart:async';
import 'package:flutter/material.dart';

import '../../smart_import.dart';

class SmartVideoPlayerGridWebMacosWidget extends StatefulWidget {
  final double height;
  final double width;
  final String debugLabelText;
  final String thumbnailUrl;
  final String videoUrl;
  final bool? isAsset;
  final LastWatchedState? lastWatchedState;
  final bool? looping;
  final VoidCallback onClickGridItem;
  final Function? onVideoError;
  final Function? onImageError;
  final BorderRadiusGeometry? borderRadius;
  final MuteConfig? muteConfig;
  final DurationConfig? durationConfig;
  final SeekBarConfig? seekBarConfig;
  final VideoConfig? videoConfig;
  final LoadingIndicationConfig? loadingIndicationConfig;

  const SmartVideoPlayerGridWebMacosWidget({
    required Key key,
    required this.height,
    required this.width,
    required this.debugLabelText,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isAsset,
    this.lastWatchedState,
    this.looping,
    required this.onClickGridItem,
    this.onVideoError,
    this.onImageError,
    this.borderRadius,
    this.muteConfig,
    this.durationConfig,
    this.seekBarConfig,
    this.videoConfig,
    this.loadingIndicationConfig
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartVideoPlayerGridWebMacosWidgetState();
}

class _SmartVideoPlayerGridWebMacosWidgetState extends State<SmartVideoPlayerGridWebMacosWidget> {

  final smartManager = SmartManager();
  late SmartVideoInfo smartVideoInfo;
  late final Stream<PlayerEvent> _videoStream;

  PlayerVariant variant = PlayerVariant.grid;
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
      isAsset: widget.isAsset,
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
          if(smartManager.selectedKey != widget.key) {
            smartManager.startDrawing(key: widget.key!);
          }
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
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
                      onImageError: widget.onImageError,
                      loadingIndicationConfig: widget.loadingIndicationConfig,
                    );
                  } else {
                    switch (event!.status) {
                      case PlayerEventStatus.loading:
                        content = LoadingThumbnailFace(
                          width: widget.width,
                          height: widget.height,
                          thumbnailUrl: widget.thumbnailUrl,
                          onImageError: widget.onImageError,
                          loadingIndicationConfig: widget.loadingIndicationConfig,
                        );
                        break;
                      case PlayerEventStatus.failed:
                        content = const ErrorFace(text: 'Failed to load video');
                        widget.onVideoError?.call(event.error);
                        break;
                      case PlayerEventStatus.ready:
                        content = VideoFace(
                          controller: event.controller!,
                          playMode: playMode,
                          variant: variant,
                          muteConfig: widget.muteConfig,
                          durationConfig: widget.durationConfig,
                          seekBarConfig: widget.seekBarConfig,
                          videoConfig: widget.videoConfig
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
        ),
      ),
    );
  }
}