import "dart:core";

extension ListX<E extends String> on List<E> {
  String get firstOrEmpty {
    try {
      return first;
    } catch (e) {
      return "";
    }
  }
}
