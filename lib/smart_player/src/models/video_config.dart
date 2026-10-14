import 'package:flutter/material.dart';

class VideoConfig {
  final double bufferingIndicatorWidth;
  final Color bufferingIndicatorColor;
  final Color backgroundColor;
  final BoxFit videoFit;
  final Icon playIcon;
  final Icon pauseIcon;
  final Icon maximizeIcon;
  final Icon minimizeIcon;

  const VideoConfig({
    this.bufferingIndicatorWidth = 2.5,
    this.bufferingIndicatorColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.videoFit = BoxFit.cover,
    this.playIcon = const Icon(Icons.play_circle_fill, color: Colors.white),
    this.pauseIcon = const Icon(Icons.pause_circle_filled, color: Colors.white),
    this.maximizeIcon = const Icon(Icons.fullscreen, color: Colors.white),
    this.minimizeIcon = const Icon(Icons.fullscreen_exit, color: Colors.white),
  });
}
