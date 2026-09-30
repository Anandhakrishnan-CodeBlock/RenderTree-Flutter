import 'package:flutter/material.dart';
import 'package:renter_tree_test/constants/video_url.dart';
import '../smart_player/smart_import.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<StatefulWidget> createState() => GridScreenState();
}

class GridScreenState extends State<GridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: VideoUrl.videoUrls.length,
        itemBuilder: (context, index) {
          final itemKey = ValueKey("grid_screen_$index");
          return SmartListItem(
            itemKey: itemKey,
            isFirst: index == 0,
            isLast: index == VideoUrl.videoUrls.length - 1,
            duration: const Duration(milliseconds: 200),
            child: SmartGridPlayer(
              key: itemKey,
              videoUrl: VideoUrl.videoUrls[index],
              thumbnailUrl: VideoUrl.thumbnailUrls[index],
              debugLabelText: 'Grid $index',
              height: 100,
              width: double.infinity,
              playMode: PlayMode.auto,
              lastWatchedStatus: LastWatchedState.save,
              looping: false,
              onClickGridItem: () {
                debugPrint('Tapped on Grid $index');
              },
            ),
          );
        },
      ),
    );
  }
}
