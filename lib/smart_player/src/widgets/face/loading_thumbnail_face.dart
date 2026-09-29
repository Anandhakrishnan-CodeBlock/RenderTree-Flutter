import 'package:flutter/material.dart';
import 'package:renter_tree_test/smart_player/src/widgets/face/loading_face.dart';
import 'package:renter_tree_test/smart_player/src/widgets/face/thumbnail_image.dart';

class LoadingThumbnailFace extends StatelessWidget {
  final double width;
  final double height;
  final String? thumbnailUrl;

  const LoadingThumbnailFace({
    super.key,
    required this.width,
    required this.height,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return (thumbnailUrl != null)
        ? ThumbnailImage(
            width: width,
            height: height,
            thumbnailUrl: thumbnailUrl!,
          )
        : LoadingFace(
            width: width,
            height: height,
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(),
          );
    ;
  }
}
