import 'package:flutter/material.dart';
import 'package:renter_tree_test/screen/tab_children/tab_view_one.dart';
import 'package:renter_tree_test/screen/tab_children/tab_view_three.dart';
import 'package:renter_tree_test/screen/tab_children/tab_view_two.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.all(0.0),
          title: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.ondemand_video_rounded)),
              Tab(icon: Icon(Icons.view_list_rounded)),
              Tab(icon: Icon(Icons.playlist_play_rounded)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TabViewOne(),
            Column(
              children: [
                Expanded(child: TabViewTwo()),
              ],
            ),
            TabViewThree(),
          ],
        ),
      ),
    );
  }
}