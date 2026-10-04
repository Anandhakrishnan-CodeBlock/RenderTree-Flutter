import 'package:flutter/widgets.dart';
import '../smart_player/smart_import.dart';

class SmartGridItem extends StatelessWidget {
  final Key itemKey;
  final int index;
  final GridConfig gridConfig;
  final Duration settleDuration;
  final double? stepExtent;
  final double visibleThreshold;
  final Widget child;

  const SmartGridItem({
    super.key,
    required this.itemKey,
    required this.index,
    required this.gridConfig,
    required this.child,
    this.stepExtent,
    this.visibleThreshold = 0.5,
    this.settleDuration = const Duration(milliseconds: 200)
  });

  @override
  Widget build(BuildContext context) {
    return SmartGridItemWidget(
      itemKey: itemKey,
      index: index,
      gridConfig: gridConfig,
      visibleThreshold: visibleThreshold,
      stepExtent: stepExtent,
      settleDuration: settleDuration,
      child: child,
    );
  }
}