class ListUtils {
  static List<T> withSeparator<T>(T Function(int index) builder, T Function(int index) separatorBuilder, int count) {
    final _children = <T>[];
    for (int i = 0; i < count * 2 - 1; i++) {
      final index = i ~/ 2;

      if (i > 0 && i.isOdd) {
        _children.add(separatorBuilder(index));
      }

      if (i.isEven) {
        _children.add(builder(index));
      }
    }

    return _children;
  }
}
