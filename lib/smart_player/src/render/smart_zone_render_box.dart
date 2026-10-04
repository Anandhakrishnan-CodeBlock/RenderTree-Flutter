import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../smart_import.dart';

class SmartZoneRenderBox extends RenderProxyBox {
  Key itemKey;
  VoidCallback? onPainted;

  SmartZoneRenderBox({
    required this.itemKey,
    this.onPainted,
    RenderBox? child,
  }) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    onPainted?.call();
    super.paint(context, offset);
  }

  double computeScore() {
    if (!attached || size.isEmpty) return 0.0;

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(this);

    // Item bounds in global coordinates.
    final Offset itemOffset = localToGlobal(Offset.zero);
    final Rect itemRect = itemOffset & size;

    // Viewport bounds in global coordinates.
    final RenderBox viewportBox = viewport as RenderBox;
    final Offset viewportOffset = viewportBox.localToGlobal(Offset.zero);
    final Rect viewportRect = viewportOffset & viewportBox.size;

    // Divide the viewport into 3 equal zones.
    final double zoneHeight = viewportRect.height / 3.0;
    late final Rect zoneRect;

    zoneRect = Rect.fromLTWH(
      viewportRect.left,
      viewportRect.top + zoneHeight,
      viewportRect.width,
      zoneHeight,
    );

    final Rect intersection = itemRect.intersect(zoneRect);
    if (intersection.width <= 0 || intersection.height <= 0) return 0.0;

    final double itemArea = size.width * size.height;
    if (itemArea <= 0) return 0.0;

    return (intersection.width * intersection.height) / itemArea;
  }

  int computeActiveIndex({required double itemHeight,
    required double rowExtent,
    required double visibleThreshold,
    required double edgeTolerance,
    required double? stepExtent,
    required ScrollPosition? scrollPosition,
    required GridConfig gridConfig,
  }) {
    final itemCount = gridConfig.itemCount;
    if (itemCount == 0 || rowExtent <= 0 || !itemHeight.isFinite) return -1;

    final cols = gridConfig.crossAxisCount;
    final lastIndex = itemCount - 1;

    double pixels = 0;
    bool atBottom = false;
    final position = scrollPosition;
    if (position != null && position.hasContentDimensions) {
      pixels = position.pixels;
      atBottom =
          position.maxScrollExtent > 0 &&
              pixels >= position.maxScrollExtent - edgeTolerance;
    }
    if (atBottom) return lastIndex;

    final pad = gridConfig.padding.top;
    final shift = (1 - visibleThreshold) * itemHeight;
    final lastRow = lastIndex ~/ cols;

    final row = math.min(
      lastRow,
      math.max(0, ((pixels - pad - shift) / rowExtent).ceil()),
    );

    final start = row == 0 ? 0.0 : pad + (row - 1) * rowExtent + shift;
    final end = pad + row * rowExtent + shift;
    final length = math.max(1.0, end - start);
    final into = math.max(0.0, pixels - start);

    final firstInRow = row * cols;
    final itemsInRow = math.min(cols, itemCount - firstInRow);

    final evenStep = length / itemsInRow;
    final step = stepExtent == null
        ? evenStep
        : math.min(stepExtent, evenStep);
    final col = math.min((into / step).floor(), itemsInRow - 1);

    return firstInRow + col;
  }
}