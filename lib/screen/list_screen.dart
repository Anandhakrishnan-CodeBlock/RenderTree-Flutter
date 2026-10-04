import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/assets/image_urls.dart';
import 'package:renter_tree_test/smart_player/src/assets/video_urls.dart';
import '../smart_player/smart_import.dart';

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
        itemCount: ImageUrls.landscapeListImages.length,
        itemBuilder: (context, index) {
          final itemKey = ValueKey("list_screen_$index");
          return Column(
            children: [
              SmartListItem(
                itemKey: itemKey,
                isFirst: index == 0,
                isLast: index == ImageUrls.landscapeListImages.length - 1,
                duration: const Duration(milliseconds: 200),
                child: SmartListPlayer(
                  key: itemKey,
                  videoUrl: VideoUrls.landscapeVideo,
                  thumbnailUrl: ImageUrls.landscapeListImages[index],
                  debugLabelText: 'Video $index',
                  height: 240,
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
