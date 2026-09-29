import 'package:flutter/material.dart';

final class DurationBadge extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final bool compact;

  const DurationBadge({
    super.key,
    required this.position,
    required this.duration,
    this.compact = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${_formatDuration(position)} / ${_formatDuration(duration)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 11 : 12,
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