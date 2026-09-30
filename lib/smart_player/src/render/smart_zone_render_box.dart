import 'package:flutter/rendering.dart';

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
}