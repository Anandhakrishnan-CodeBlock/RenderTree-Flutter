import 'package:flutter/material.dart';

import '../../../smart_import.dart';

final class DurationBadge extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final DurationConfig? durationConfig;

  const DurationBadge({
    super.key,
    required this.position,
    required this.duration,
    this.durationConfig = const DurationConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final config = durationConfig ?? const DurationConfig();
    if (!config.showDuration) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: config.padding,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.backgroundRadius,
      ),
      child: Text(
        '${_formatDuration(position)} / ${_formatDuration(duration)}',
        style: TextStyle(
          color: config.textColor,
          fontSize: config.textSize,
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '$m:${two(s)}';
  }
}