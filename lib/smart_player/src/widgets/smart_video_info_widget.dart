import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../smart_player.dart';

class SmartVideoInfoWidget extends StatefulWidget {
  final Function onPaint;
  final Widget child;

  const SmartVideoInfoWidget({
    super.key,
    required this.onPaint,
    required this.child,
  });

  @override
  State<SmartVideoInfoWidget> createState() => _SmartVideoInfoWidgetState();
}

class _SmartVideoInfoWidgetState extends State<SmartVideoInfoWidget> {

  @override
  Widget build(BuildContext context) {

    final bool activateOnPaint = !SmartListScope.isInsideList(context);
    return _VideoInfoRenderObject(
      key: widget.key!,
      onPaint: widget.onPaint,
      activateOnPaint: activateOnPaint,
      child: widget.child,
    );
  }
}

class _VideoInfoRenderObject extends SingleChildRenderObjectWidget {

  final Function onPaint;
  final bool activateOnPaint;

  const _VideoInfoRenderObject({
    required Key key,
    required Widget child,
    required this.onPaint,
    required this.activateOnPaint,
  }) : super(key: key, child: child);

  @override
  VideoInfoRenderObject createRenderObject(BuildContext context) {
    return VideoInfoRenderObject(
      onPaint: onPaint,
      activateOnPaint: activateOnPaint,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      VideoInfoRenderObject renderObject,
      ) {
    renderObject.activateOnPaint = activateOnPaint;
  }
}

/// When [activateOnPaint] is true (this player is NOT inside a (SmartListItemWidget)
/// When [activateOnPaint] is false (inside a list)

class VideoInfoRenderObject extends RenderProxyBox {

  bool activateOnPaint;
  final Function onPaint;

  VideoInfoRenderObject({
    required this.activateOnPaint,
    required this.onPaint
  });


  @override
  void paint(PaintingContext context, Offset offset) {
    if (activateOnPaint) {
      onPaint(activateOnPaint);
    }
    super.paint(context, offset);
  }
}