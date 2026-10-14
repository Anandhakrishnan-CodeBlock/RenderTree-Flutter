import 'package:flutter/material.dart';

import '../../../smart_import.dart';

final class ThumbnailImage extends StatelessWidget {
  final double width;
  final double height;
  final String thumbnailUrl;
  final Function? onImageError;

  const ThumbnailImage({
    super.key,
    required this.width,
    required this.height,
    required this.thumbnailUrl,
    this.onImageError,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      key: key,
      thumbnailUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return LoadingFace(
          key: key,
          width: width,
          height: height,
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        onImageError?.call(error);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Thumbnail failed to load',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
