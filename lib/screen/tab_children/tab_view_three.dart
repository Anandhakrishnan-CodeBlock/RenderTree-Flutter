import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/smart_player.dart';
import 'package:renter_tree_test/smart_player/src/assets/image_urls.dart';
import 'package:renter_tree_test/smart_player/src/assets/video_urls.dart';
import 'package:renter_tree_test/smart_player/src/enums/last_watched_status.dart';
import 'package:renter_tree_test/smart_player/src/enums/play_mode.dart';

class TabViewThree extends StatelessWidget {
  const TabViewThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SmartPlayer(
                key: ValueKey("tab_view_three"),
                videoUrl: VideoUrls.landscapeVideo,
                debugLabelText: "tab_view_three",
                width: double.infinity,
                thumbnailUrl: ImageUrls.landscapeImages[4],
                playMode: PlayMode.auto,
                lastWatchedStatus: LastWatchedState.save,
                isAsset: false,
                height: 250,
              ),
            ],
          ),
        )
    );
  }
}