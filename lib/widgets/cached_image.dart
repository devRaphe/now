import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key key,
    @required this.url,
    this.loadingColor = Colors.white54,
    this.fit = BoxFit.cover,
    this.height,
  }) : super(key: key);

  final String url;
  final Color loadingColor;
  final BoxFit fit;
  final double height;

  static final imageKey = ValueKey("image");
  static final emptyKey = ValueKey("empty");
  static final loadingKey = ValueKey("loading");

  @override
  Widget build(BuildContext context) {
    return url == null
        ? Material(
            key: emptyKey,
            color: AppColors.primary,
            child: Icon(Icons.broken_image, color: AppColors.white.shade300),
          )
        : CachedNetworkImage(
            key: imageKey,
            placeholder: (context, url) => Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: LoadingSpinner.circle(key: loadingKey, color: loadingColor),
              ),
            ),
            imageUrl: url,
            fit: fit,
            height: height,
          );
  }
}
