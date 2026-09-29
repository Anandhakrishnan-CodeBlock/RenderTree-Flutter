import 'package:flutter/material.dart';
import 'package:renter_tree_test/screen/app_navigation_drawer.dart';

import 'smart_player/src/controls/navigation_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [NavigationController()],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AppNavigationDrawer(),
    );
  }
}

