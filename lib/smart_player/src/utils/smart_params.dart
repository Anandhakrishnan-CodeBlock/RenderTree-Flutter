import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

typedef OnLoading = void Function({
required Key key
});

typedef OnVideoReady = void Function({
required Key key,
required VideoPlayerController controller,
});

typedef OnVideoError = void Function({
required Key key,
required Object error,
});

typedef OnWinnerCallback = void Function({required Key key});