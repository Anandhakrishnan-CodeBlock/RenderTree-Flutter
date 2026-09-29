import 'package:flutter/widgets.dart';
import 'package:renter_tree_test/smart_player/smart_player.dart';

abstract class NavigationControls {
  void didPush();
  void didPop();
}

class NavigationController extends NavigatorObserver {
  NavigationController._internal();

  static final NavigationController _instance =
      NavigationController._internal();

  factory NavigationController() {
    return _instance;
  }

  final NavigationControls navigationControls = SmartManager();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    navigationControls.didPush();
    debugPrint('Nav - Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    navigationControls.didPop();
    debugPrint('Nav - Popped route: ${route.settings.name}');
  }
}
