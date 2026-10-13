import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Tells you when its child starts / stops being part of the drawn scene.
///
/// Why the old version stopped firing in GridView / TabBarView:
///  * `RenderObject.paint` only runs when something marks it dirty. Items of
///    GridView / ListView / PageView (TabBarView) sit in their own
///    RepaintBoundary, so repaints elsewhere never reach them.
///  * Video frames are drawn by the engine through a Texture, they do not go
///    through Dart's paint at all.
/// So while a video plays quietly there may be NO paint call for seconds,
/// and a "reset the timer on every paint" watchdog fires by mistake.
///
/// This version reports TRANSITIONS only:
///  * `true`  -> the child is in the scene (visible to the compositor)
///  * `false` -> a frame was drawn and the child was not in it
///    (tab switched, IndexedStack / Offstage, scrolled away and removed...)
///
/// It uses a layer that must be re-added to the scene on every composite
/// (the same trick the `visibility_detector` package uses), so retained
/// layers cannot hide a repaint from it. While the child is not drawn it
/// costs nothing.
///
/// Note: "in the scene" is not "inside the viewport". Items in a list's
/// cacheExtent (a few hundred px outside the screen) still count as drawn.
class PaintListenerWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<bool> onPaintStateChanged;

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
      RenderPaintListener renderObject,
      ) {
    renderObject.onPaintStateChanged = onPaintStateChanged;
  }
}

class RenderPaintListener extends RenderProxyBox {
  RenderPaintListener(this.onPaintStateChanged);

  ValueChanged<bool> onPaintStateChanged;

  bool _isPainting = false;
  bool _reachedThisFrame = false;
  bool _checkScheduled = false;

  // We push our own layer, so ancestors must know we need compositing.
  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final probe = (layer as _PaintProbeLayer?) ?? _PaintProbeLayer(_onReached);
    probe.onAddedToScene = _onReached;
    layer = probe;
    context.pushLayer(probe, super.paint, offset);
  }

  /// Called while the scene is being composited. Never run user code here.
  void _onReached() {
    _reachedThisFrame = true;
    _scheduleCheck();
  }

  void _scheduleCheck() {
    if (_checkScheduled) return;
    _checkScheduled = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!attached) return;

      final painting = _reachedThisFrame;
      _reachedThisFrame = false;

      if (painting != _isPainting) {
        _isPainting = painting;
        onPaintStateChanged(painting);
      }

      // While drawn, look again after the next frame; if that frame no
      // longer reaches us we report `false`. Does not schedule frames itself.
      if (_isPainting) _scheduleCheck();
    });
  }
}

class _PaintProbeLayer extends ContainerLayer {
  _PaintProbeLayer(this.onAddedToScene);

  VoidCallback onAddedToScene;

  // Ask the compositor to call addToScene every frame, even when nothing
  // below us was repainted.
  @override
  bool get alwaysNeedsAddToScene => true;

  @override
  void addToScene(ui.SceneBuilder builder) {
    onAddedToScene();
    super.addToScene(builder);
  }
}