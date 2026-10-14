import 'package:flutter/material.dart';

class DurationConfig {
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry backgroundRadius;
  final Color textColor;
  final double textSize;
  final bool showDuration;

  const DurationConfig({
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.backgroundColor = Colors.black45,
    this.backgroundRadius = const BorderRadiusGeometry.all(
      Radius.circular(6.0),
    ),
    this.textColor = Colors.white,
    this.textSize = 11,
    this.showDuration = true,
  });
}
