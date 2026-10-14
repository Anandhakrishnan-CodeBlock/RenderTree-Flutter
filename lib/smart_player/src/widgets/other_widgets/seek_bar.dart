import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../smart_import.dart';

final class SeekBar extends StatefulWidget {
  final VideoPlayerController controller;
  final SeekBarConfig? seekBarConfig;

  const SeekBar({
    super.key,
    required this.controller,
    this.seekBarConfig = const SeekBarConfig(),
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  bool _dragging = false;
  double _dragValue = 0;

  @override
  Widget build(BuildContext context) {
    final config = widget.seekBarConfig ?? const SeekBarConfig();
    if (!config.showSeekBar) {
      return const SizedBox.shrink();
    }
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final double max = value.duration.inMilliseconds > 0
            ? value.duration.inMilliseconds.toDouble()
            : 1.0;
        final double current = _dragging
            ? _dragValue
            : value.position.inMilliseconds.toDouble().clamp(0, max);

        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: config.trackHeight,
            thumbShape: config.thumbShape,
            overlayShape: config.overlayShape,
            activeTrackColor: config.activeTrackColor,
            thumbColor: config.thumbColor,
            inactiveTrackColor: config.inactiveTrackColor,
            padding: config.padding,
          ),
          child: Slider(
            min: 0,
            max: max,
            value: current.clamp(0, max),
            onChangeStart: (_) => setState(() => _dragging = true),
            onChanged: (v) => setState(() => _dragValue = v),
            onChangeEnd: (v) async {
              await widget.controller.seekTo(Duration(milliseconds: v.round()));
              if (mounted) setState(() => _dragging = false);
            },
          ),
        );
      },
    );
  }
}