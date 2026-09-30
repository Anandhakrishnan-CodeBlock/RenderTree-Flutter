import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import 'package:renter_tree_test/screen/bottom_nav_children/view_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<StatefulWidget> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _index = 0;
  final List<Widget> _child = [
    ViewScreen(
      valueKey: ValueKey("index_0"),
      debugLabelText: "index_0",
      thumbnailUrl: VideoUrl.thumbnailUrls[0],
      videoUrl: VideoUrl.url1,
    ),
    ViewScreen(
      valueKey: ValueKey("index_1"),
      debugLabelText: "index_1",
      thumbnailUrl: VideoUrl.thumbnailUrls[1],
      videoUrl: VideoUrl.url2,
    ),
    ViewScreen(
      valueKey: ValueKey("index_2"),
      debugLabelText: "index_2",
      thumbnailUrl: VideoUrl.thumbnailUrls[2],
      videoUrl: VideoUrl.url3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.smart_display_outlined),
            label: 'View 1',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_display_outlined),
            label: 'View 2',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_display_outlined),
            label: 'View 3',
          ),
        ],
      ),
    );
  }
}
