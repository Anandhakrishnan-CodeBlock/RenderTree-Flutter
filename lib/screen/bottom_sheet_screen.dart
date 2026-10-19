import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/smart_import.dart';
import 'package:renter_tree_test/smart_player/src/assets/video_urls.dart';

class BottomSheetScreen extends StatelessWidget {
  const BottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SmartPlayer(
            key: ValueKey('bottom_sheet_1'),
            videoUrl: VideoUrls.landscapeVideo,
            debugLabelText: "bottom_sheet_1",
            width: double.infinity,
            //thumbnailUrl: ImageUrls.landscapeImages[9],
            playMode: PlayMode.auto,
            lastWatchedState: LastWatchedState.save,
            isAsset: false,
            looping: true,
            height: 250,
            loadingIndicationConfig: LoadingIndicationConfig(
                indicatorType: IndicatorType.circularIndicator,
                circularIndicatorColor: Colors.white,
                circularIndicatorBackgroundColor: Colors.black,
                circularIndicatorStrokeWidth: 5.0
            ),
          ),
          SizedBox(height: 35),
          ElevatedButton(
            onPressed: () {
              _showModalBottomSheet(context);
            },
            child: Text("Open Bottom Sheet"),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              SmartPlayer(
                key: ValueKey('bottom_sheet_2'),
                videoUrl: VideoUrls.landscapeVideo,
                debugLabelText: "bottom_sheet_2",
                width: double.infinity,
                playMode: PlayMode.auto,
                lastWatchedState: LastWatchedState.save,
                isAsset: false,
                looping: true,
                height: 250
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
