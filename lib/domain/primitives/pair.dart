class Pair<A, B> {
  const Pair(this.first, this.second);

  final A first;
  final B second;

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair && runtimeType == other.runtimeType && first == other.first && second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

class Pair2<A, B, C> {
  const Pair2(this.first, this.second, this.third);

  final A first;
  final B second;
  final C third;

  @override
  String toString() {
    return 'Pair2{first: $first, second: $second, third: $third}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair2 &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;
}
