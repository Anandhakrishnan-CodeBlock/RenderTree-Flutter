import 'package:flutter/material.dart';

import '../../../smart_import.dart';

final class LoadingFace extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  final List<Color>? colors;
  final List<double>? stops;
  final BorderRadius borderRadius;
  final Duration duration;
  final ShimmerDirection direction;
  final bool isLoading;
  final Widget? child;

  const LoadingFace({
    super.key,
    required this.width,
    required this.height,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.colors,
    this.stops,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.duration = const Duration(milliseconds: 1200),
    this.direction = ShimmerDirection.ltr,
    this.isLoading = true,
    this.child,
  });

  @override
  State<LoadingFace> createState() => _LoadingFaceState();
}


class _LoadingFaceState extends State<LoadingFace> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant LoadingFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading) {
      _controller.stop();
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _beginAlign() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return const Alignment(-1.8, 0);
      case ShimmerDirection.rtl:
        return const Alignment(1.8, 0);
      case ShimmerDirection.ttb:
        return const Alignment(0, -1.8);
      case ShimmerDirection.btt:
        return const Alignment(0, 1.8);
    }
  }

  Alignment _endAlign() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return const Alignment(1.8, 0);
      case ShimmerDirection.rtl:
        return const Alignment(-1.8, 0);
      case ShimmerDirection.ttb:
        return const Alignment(0, 1.8);
      case ShimmerDirection.btt:
        return const Alignment(0, -1.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child ?? SizedBox(width: widget.width, height: widget.height);
    }

    final gradientColors = widget.colors ??
        [
          widget.baseColor,
          widget.highlightColor,
          widget.baseColor,
        ];
    final gradientStops = widget.stops ?? const [0.35, 0.5, 0.65];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value; // 0 -> 1
          // Slide the gradient's alignment across the box over time.
          final begin = _beginAlign();
          final end = _endAlign();
          final dx = begin.x + (end.x - begin.x) * t;
          final dy = begin.y + (end.y - begin.y) * t;

          return ClipRRect(
            borderRadius: widget.borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.baseColor,
                gradient: LinearGradient(
                  begin: Alignment(dx - 0.6, dy - 0.6),
                  end: Alignment(dx + 0.6, dy + 0.6),
                  colors: gradientColors,
                  stops: gradientStops,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}