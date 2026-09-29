import 'package:flutter/widgets.dart';

/// Identify the nearest parent type SmartListItemWidget

class SmartListScope extends InheritedWidget {
  const SmartListScope({super.key, required super.child});

  static bool isInsideList(BuildContext context) {
    return context.getElementForInheritedWidgetOfExactType<SmartListScope>() != null;
  }

  @override
  bool updateShouldNotify(SmartListScope oldWidget) => false;
}