import 'package:flutter/material.dart';
import '../../smart_player/smart_import.dart';

class ViewScreen extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final Key valueKey;
  final String debugLabelText;

  const ViewScreen({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.valueKey,
    required this.debugLabelText,
  });

  @override
  State<StatefulWidget> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SmartPlayer(
            key: widget.valueKey,
            videoUrl: widget.videoUrl,
            debugLabelText: widget.debugLabelText,
            width: double.infinity,
            thumbnailUrl: widget.thumbnailUrl,
            playMode: PlayMode.auto,
            lastWatchedStatus: LastWatchedState.save,
            isAsset: false,
            looping: true,
            height: 250
          ),
        ],
      ),
    );
  }
}
