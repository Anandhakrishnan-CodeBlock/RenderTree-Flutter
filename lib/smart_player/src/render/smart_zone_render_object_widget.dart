import 'package:flutter/widgets.dart';

import '../../smart_import.dart';

class SmartZoneRenderObjectWidget extends SingleChildRenderObjectWidget {
  final Key itemKey;
  final ValueChanged<SmartZoneRenderBox> onRenderObjectCreated;
  final VoidCallback onPainted;

  const SmartZoneRenderObjectWidget({
    super.key,
    required this.itemKey,
    required this.onRenderObjectCreated,
    required this.onPainted,
    required Widget child,
  }) : super(child: child);

  @override
  SmartZoneRenderBox createRenderObject(BuildContext context) {
    final box = SmartZoneRenderBox(
      itemKey: itemKey,
      onPainted: onPainted,
    );
    onRenderObjectCreated(box);
    return box;
  }

  @override
  void updateRenderObject(BuildContext context, SmartZoneRenderBox renderObject) {
    renderObject
      ..itemKey = itemKey
      ..onPainted = onPainted;
  }
}