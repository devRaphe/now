Map<String, List<T>> groupModelBy<T>(List<T> list, String Function(T) fn) {
  return list?.fold(<String, List<T>>{}, (rv, T x) {
        final key = fn?.call(x);
        if (key == null) {
          return rv;
        }
        (rv[key] = rv[key] ?? <T>[]).add(x);
        return rv;
      }) ??
      {};
}
