import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PaintListenerWidget extends SingleChildRenderObjectWidget {
  final Function onPaintStateChanged;

  const PaintListenerWidget({
    super.key,
    required this.onPaintStateChanged,
    required super.child,
  });

  @override
  RenderPaintListener createRenderObject(BuildContext context) {
    return RenderPaintListener(onPaintStateChanged);
  }

  @override
  void updateRenderObject(
      BuildContext context,
      RenderPaintListener renderObject) {
    renderObject.onPaint = onPaintStateChanged;
  }
}

class RenderPaintListener extends RenderProxyBox {
  Function onPaint;
  RenderPaintListener(this.onPaint);

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}