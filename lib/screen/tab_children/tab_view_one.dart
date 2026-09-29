import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import 'package:renter_tree_test/smart_player/smart_video_player.dart';
import 'package:renter_tree_test/smart_player/src/enums/last_watched_status.dart';
import 'package:renter_tree_test/smart_player/src/enums/play_mode.dart';
import 'package:renter_tree_test/smart_player/src/enums/player_variant.dart';

class TabViewOne extends StatelessWidget {
  const TabViewOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SmartVideoPlayer(
            key: ValueKey("tab_view_one"),
            videoUrl: VideoUrl.url5,
            debugLabelText: "tab_view_one",
            width: double.infinity,
            thumbnailUrl: VideoUrl.thumbnailUrls[8],
            playMode: PlayMode.auto,
            lastWatchedStatus: LastWatchedState.save,
            isAsset: false,
            looping: true,
            height: 250,
            variant: PlayerVariant.list,
          ),
        ],
      ),
    );
  }
}