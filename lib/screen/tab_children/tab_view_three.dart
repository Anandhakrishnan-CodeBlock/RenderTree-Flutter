import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import 'package:renter_tree_test/smart_player/smart_video_player.dart';
import 'package:renter_tree_test/smart_player/src/enums/last_watched_status.dart';
import 'package:renter_tree_test/smart_player/src/enums/play_mode.dart';
import 'package:renter_tree_test/smart_player/src/enums/player_variant.dart';

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
              SmartVideoPlayer(
                key: ValueKey("tab_view_three"),
                videoUrl: VideoUrl.url4,
                debugLabelText: "tab_view_three",
                width: double.infinity,
                thumbnailUrl: VideoUrl.thumbnailUrls[4],
                playMode: PlayMode.manual,
                variant: PlayerVariant.detail,
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