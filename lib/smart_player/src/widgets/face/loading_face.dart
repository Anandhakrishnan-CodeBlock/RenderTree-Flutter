import 'package:flutter/material.dart';

import '../../../smart_import.dart';

final class LoadingFace extends StatefulWidget {
  final double width;
  final double height;
  final LoadingIndicationConfig? loadingIndicationConfig;
  final Widget? child;

  const LoadingFace({
    super.key,
    required this.width,
    required this.height,
    this.loadingIndicationConfig = const LoadingIndicationConfig(),
    this.child,
  });

  @override
  State<LoadingFace> createState() => _LoadingFaceState();
}

class _LoadingFaceState extends State<LoadingFace> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  LoadingIndicationConfig get _config =>
      widget.loadingIndicationConfig ?? const LoadingIndicationConfig();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _config.duration,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loadingIndicationConfig?.indicatorType == IndicatorType.circularIndicator) {
      return Container(
          width: widget.width,
          height: widget.height,
          color: widget.loadingIndicationConfig?.circularIndicatorBackgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              color: widget.loadingIndicationConfig?.baseColor,
              strokeWidth: widget.loadingIndicationConfig?.circularIndicatorStrokeWidth,
            ),
          )
      );
    }

    final config = _config;
    final gradientColors = config.colors ??
        [
          config.baseColor,
          config.highlightColor,
          config.baseColor,
        ];
    final gradientStops = config.stops ?? const [0.35, 0.5, 0.65];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final begin = _beginAlign();
          final end = _endAlign();
          final dx = begin.x + (end.x - begin.x) * t;
          final dy = begin.y + (end.y - begin.y) * t;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: config.baseColor,
              gradient: LinearGradient(
                begin: Alignment(dx - 0.6, dy - 0.6),
                end: Alignment(dx + 0.6, dy + 0.6),
                colors: gradientColors,
                stops: gradientStops,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LoadingFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller.isAnimating) {
      _controller.repeat();
    }

    final oldConfig = oldWidget.loadingIndicationConfig ?? const LoadingIndicationConfig();
    if (_config.duration != oldConfig.duration) {
      _controller.duration = _config.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _beginAlign() {
    switch (_config.direction) {
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
    switch (_config.direction) {
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
}