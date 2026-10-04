import 'package:flutter/widgets.dart';

class GridConfig {
  final int itemCount;
  final EdgeInsets padding;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  /// Leave null to size items with [childAspectRatio].
  /// Never pass 0 here: it makes every tile 0px high.
  final double? mainAxisExtent;

  const GridConfig({
    required this.itemCount,
    this.padding = EdgeInsets.zero,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    this.mainAxisExtent,
  }) : assert(crossAxisCount > 0),
        assert(mainAxisExtent == null || mainAxisExtent > 0);
}