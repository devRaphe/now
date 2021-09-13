import 'package:borome/domain.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class SlideShowItem extends StatelessWidget {
  const SlideShowItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ImageListItem item;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: CachedImage(url: item.url),
      ),
    );
  }
}
