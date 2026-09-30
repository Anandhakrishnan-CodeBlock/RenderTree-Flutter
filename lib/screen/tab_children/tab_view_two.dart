import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import 'package:renter_tree_test/smart_player/smart_list_item.dart';
import 'package:renter_tree_test/smart_player/smart_list_player.dart';
import 'package:renter_tree_test/smart_player/src/enums/last_watched_status.dart';
import 'package:renter_tree_test/smart_player/src/enums/play_mode.dart';

class TabViewTwo extends StatelessWidget {
  const TabViewTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: VideoUrl.videoUrls.length,
        itemBuilder: (context, index) {
          final itemKey = ValueKey("tab_view_two_$index");
          return Column(
            children: [
              SmartListItem(
                itemKey: itemKey,
                isFirst: index == 0,
                isLast: index == VideoUrl.videoUrls.length - 1,
                duration: const Duration(milliseconds: 200),
                child: SmartListPlayer(
                  key: itemKey,
                  videoUrl: VideoUrl.videoUrls[index],
                  thumbnailUrl: VideoUrl.thumbnailUrls[index],
                  debugLabelText: 'Video $index',
                  height: 320,
                  width: double.infinity,
                  playMode: PlayMode.auto,
                  lastWatchedStatus: LastWatchedState.save,
                  looping: false,
                  onClickListItem: () {
                    debugPrint('Tapped on Video $index');
                  },
                ),
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.insert_emoticon, color: Colors.white),
                ),
                title: const Text('John Doe'),
                subtitle: const Text('Available • Tap to chat'),
                onTap: () {
                  debugPrint('Tapped on John Doe');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}