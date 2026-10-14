import 'package:flutter/material.dart';

class SeekBarConfig {
  final double trackHeight;
  final SliderComponentShape thumbShape;
  final SliderComponentShape overlayShape;
  final Color activeTrackColor;
  final Color thumbColor;
  final Color inactiveTrackColor;
  final EdgeInsets padding;
  final bool showSeekBar;

  const SeekBarConfig({
    this.trackHeight = 2,
    this.thumbShape = const RoundSliderThumbShape(enabledThumbRadius: 4),
    this.overlayShape = const RoundSliderOverlayShape(overlayRadius: 8),
    this.activeTrackColor = Colors.redAccent,
    this.thumbColor = Colors.redAccent,
    this.inactiveTrackColor = Colors.white30,
    this.padding = const EdgeInsets.all(4.0),
    this.showSeekBar = true,
  });
}
