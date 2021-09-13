import 'package:flutter/foundation.dart';

class ImageListItem {
  const ImageListItem({@required this.id, @required this.url, @required this.index});

  final String id;
  final String url;
  final int index;

  @override
  String toString() {
    return 'ImageListItem{id: $id, url: $url, index: $index}';
  }
}
