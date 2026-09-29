import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final class SeekBar extends StatefulWidget {
  final VideoPlayerController controller;
  final Color color;
  final bool compact;

  const SeekBar({
    super.key,
    required this.controller,
    required this.color,
    this.compact = false,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  bool _dragging = false;
  double _dragValue = 0;

  @override
  Widget build(BuildContext context) {
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
            trackHeight: widget.compact ? 2 : 4,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: widget.compact ? 4 : 6,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: widget.compact ? 8 : 14,
            ),
            activeTrackColor: widget.color,
            thumbColor: widget.color,
            inactiveTrackColor: Colors.white30,
            padding: EdgeInsets.all(4.0)
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