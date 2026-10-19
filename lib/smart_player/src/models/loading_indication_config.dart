import 'package:flutter/material.dart';

import '../../smart_import.dart';

class LoadingIndicationConfig {
  final IndicatorType indicatorType;
  final Color baseColor;
  final Color highlightColor;
  final List<Color>? colors;
  final List<double>? stops;
  final Duration duration;
  final ShimmerDirection direction;
  final Color? circularIndicatorColor;
  final Color? circularIndicatorBackgroundColor;
  final double? circularIndicatorStrokeWidth;

  const LoadingIndicationConfig({
    this.indicatorType = IndicatorType.shimmer,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.colors,
    this.stops,
    this.duration = const Duration(milliseconds: 1200),
    this.direction = ShimmerDirection.ltr,
    this.circularIndicatorColor = const Color(0xFFE0E0E0),
    this.circularIndicatorBackgroundColor = Colors.black,
    this.circularIndicatorStrokeWidth = 2.0,
  });
}