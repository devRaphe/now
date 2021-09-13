import 'image_list_item.dart';

class ImageList {
  ImageList(this.items) : length = items.length;

  final List<ImageListItem> items;
  final int length;

  ImageListItem get first => items.first;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

extension ListImageListItemX on List<ImageListItem> {
  ImageList toImageList() {
    return ImageList(this);
  }
}
