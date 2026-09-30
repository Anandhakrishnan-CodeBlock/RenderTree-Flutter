import 'package:video_player/video_player.dart';

import '../../smart_import.dart';

class PlayerController implements PlayerControls {

  PlayerController._internal();
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() {
    return _instance;
  }

  VideoPlayerController? _controller;
  int _currentInitId = 0;

  @override
  VideoPlayerController? getController() {
    return _controller;
  }

  @override
  bool isPlaying() {
    if (_controller == null) return false;
    return _controller!.value.isPlaying;
  }

  @override
  Future<void> initialize(String url, bool? isAsset, bool looping) async {
    final initId = ++_currentInitId;

    // Dispose current controller if it exists
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }

    // If a new initialization started while we were disposing, stop this one.
    if (initId != _currentInitId) return;

    final controller = (isAsset ?? false)
        ? VideoPlayerController.asset(url)
        : VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await controller.initialize();

      // Double check if a newer request pre-empted us during initialization
      if (initId == _currentInitId) {
        _controller = controller;
        await _controller?.setLooping(looping);
      } else {
        await controller.dispose();
      }
    } catch (e) {
      await controller.dispose();
      if (initId == _currentInitId) {
        _controller = null;
      }
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    if (_controller != null && !_controller!.value.isPlaying) {
      await _controller!.play();
    }
  }

  @override
  Future<void> pause() async {
    if (_controller != null && _controller!.value.isPlaying) {
      await _controller!.pause();
    }
  }

  @override
  Future<void> stop() async {
    if (_controller != null) {
      await pause();
      await dispose();
    }
  }

  @override
  Future<void> seekTo(Duration position) async {
    if (_controller != null) {
      await _controller!.seekTo(position);
    }
  }

  @override
  Future<void> setLooping(bool looping) async {
    if (_controller != null) {
      await _controller!.setLooping(looping);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_controller != null) {
      await _controller!.setVolume(volume);
    }
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
  }
}