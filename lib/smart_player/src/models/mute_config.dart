import 'package:flutter/material.dart';

class MuteConfig {
  final Widget unMuteIcon;
  final Widget muteIcon;
  final double backgroundSize;
  final BoxShape backgroundShape;
  final Color backgroundColor;
  final bool showMuteIcon;

  const MuteConfig({
    this.unMuteIcon = const Icon(Icons.volume_up, color: Colors.white, size: 16),
    this.muteIcon = const Icon(Icons.volume_off, color: Colors.white, size: 16),
    this.backgroundSize = 28,
    this.backgroundShape = BoxShape.circle,
    this.backgroundColor = Colors.black45,
    this.showMuteIcon = true,
  });
}
