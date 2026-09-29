import 'package:flutter/widgets.dart';
import '../smart_player/smart_player.dart';

class SmartListItem extends StatelessWidget {
  final Key itemKey;
  final Duration duration;
  final Widget child;
  final bool isFirst;
  final bool isLast;

  const SmartListItem({
    super.key,
    required this.itemKey,
    required this.duration,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SmartListItemWidget(
      itemKey: itemKey,
      duration: duration,
      isFirst: isFirst,
      isLast: isLast,
      child: child,
    );
  }
}
