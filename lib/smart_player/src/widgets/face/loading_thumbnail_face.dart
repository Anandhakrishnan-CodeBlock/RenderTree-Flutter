import 'package:flutter/material.dart';

import '../../../smart_import.dart';

class LoadingThumbnailFace extends StatelessWidget {
  final double width;
  final double height;
  final String? thumbnailUrl;
  final Function? onImageError;
  final LoadingIndicationConfig? loadingIndicationConfig;
  const LoadingThumbnailFace({
    super.key,
    required this.width,
    required this.height,
    this.thumbnailUrl,
    this.onImageError,
    this.loadingIndicationConfig = const LoadingIndicationConfig(),
  });

  @override
  Widget build(BuildContext context) {
    return (thumbnailUrl != null)
        ? ThumbnailImage(
            width: width,
            height: height,
            thumbnailUrl: thumbnailUrl!,
            onImageError: onImageError,
          )
        : LoadingFace(
            width: width,
            height: height,
            loadingIndicationConfig: loadingIndicationConfig,
            child: Container(),
          );
  }
}
