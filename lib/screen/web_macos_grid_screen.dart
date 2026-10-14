import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/assets/image_urls.dart';
import 'package:renter_tree_test/smart_player/src/assets/video_urls.dart';
import '../smart_player/smart_import.dart';

class WebMacosGridScreen extends StatefulWidget {
  const WebMacosGridScreen({super.key});

  @override
  State<StatefulWidget> createState() => WebMacosGridState();
}

class WebMacosGridState extends State<WebMacosGridScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: ImageUrls.portraitListImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 16 / 9
        ),
        itemBuilder: (context, index) {
          final itemKey = ValueKey("grid_screen_web_mac_$index");
          return LayoutBuilder(
            builder: (context, c) {
              return SmartWebMacosGridPlayer(
                key: itemKey,
                videoUrl: VideoUrls.landscapeVideo,
                thumbnailUrl: ImageUrls.landscapeListImages[index],
                debugLabelText: 'Video $index',
                height: c.maxHeight,
                width: c.maxWidth,
                onClickGridItem: () {
                  debugPrint('Tapped on Video $index');
                },
                onVideoError: (error) {
                  debugPrint('Error: $error');
                },
              );
            },
          );
        },
      ),
    );
  }
}