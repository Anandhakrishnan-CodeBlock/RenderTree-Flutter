import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:renter_tree_test/screen/bottom_navigation.dart';
import 'package:renter_tree_test/screen/bottom_sheet_screen.dart';
import 'package:renter_tree_test/screen/tab_screen.dart';
import 'package:renter_tree_test/screen/bottom_nav_children/view_screen.dart';
import 'package:renter_tree_test/screen/list_screen.dart';
import 'package:renter_tree_test/screen/grid_screen.dart';
import 'package:renter_tree_test/smart_player/src/core/smart_manager.dart';

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  State<StatefulWidget> createState() => AppNavigationDrawerState();
}

class AppNavigationDrawerState extends State<AppNavigationDrawer> {
  int _selectedIndex = 0;
  final List<Widget> _child = [
    Container(),
    TabScreen(),
    BottomNavigation(),
    BottomSheetScreen(),
    ListScreen(),
    //GridScreen(),
  ];
  final List<String> _title = [
    "All",
    "Tab Bar View",
    "Bottom Navigation Bar",
    "Bottom Sheet",
    "List View",
    //"Grid View",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title[_selectedIndex])),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            Navigator.of(context).pop();
          });
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Options',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard),
            label: Text('All'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.featured_video_outlined),
            selectedIcon: Icon(Icons.featured_video_rounded),
            label: Text('Tab Bar View'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.padding_outlined),
            selectedIcon: Icon(Icons.padding_rounded),
            label: Text('Bottom Navigation Bar'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.call_to_action_outlined),
            selectedIcon: Icon(Icons.call_to_action_rounded),
            label: Text('Bottom Sheet'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list_rounded),
            label: Text('List View'),
          ),
          /*const NavigationDrawerDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: Text('Grid View'),
          ),*/
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: _child),
      //body: _child[_selectedIndex],
    );
  }
}
