import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import '../smart_player/smart_player.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<StatefulWidget> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: VideoUrl.videoUrls.length,
        itemBuilder: (context, index) {
          final itemKey = ValueKey("list_screen_$index");
          return Column(
            children: [
              SmartListItem(
                itemKey: itemKey,
                isFirst: index == 0,
                isLast: index == VideoUrl.videoUrls.length - 1,
                duration: const Duration(milliseconds: 200),
                child: SmartVideoPlayer(
                  key: itemKey,
                  videoUrl: VideoUrl.videoUrls[index],
                  thumbnailUrl: VideoUrl.thumbnailUrls[index],
                  debugLabelText: 'Video $index',
                  height: 320,
                  width: double.infinity,
                  playMode: PlayMode.auto,
                  variant: PlayerVariant.list,
                  lastWatchedStatus: LastWatchedState.save,
                  looping: false,
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
