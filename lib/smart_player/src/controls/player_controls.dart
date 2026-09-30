import 'package:video_player/video_player.dart';

abstract class PlayerControls {

  VideoPlayerController? getController();

  Future<void> initialize(String url, bool? isAsset, bool looping);

  Future<void> play();

  Future<void> pause();

  Future<void> stop();

  Future<void> seekTo(Duration position);

  Future<void> setLooping(bool looping);

  Future<void> setVolume(double volume);

  Future<void> dispose();

  bool isPlaying();
}