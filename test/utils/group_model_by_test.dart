import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GroupModelBy', () {
    const files = [
      MapEntry("a", 1),
      MapEntry("a", 2),
      MapEntry("b", 1),
      MapEntry("a", 3),
      MapEntry("b", 2),
      MapEntry("a", 4),
      MapEntry("c", 1),
    ];

    test('works normally', () {
      final grouped = groupModelBy<MapEntry<String, int>>(files, (file) => file.key);
      expect(grouped.length, 3);
      expect(grouped["a"].length, 4);
      expect(grouped["b"].length, 2);
      expect(grouped["c"].length, 1);
    });

    test('returns empty group with empty input', () {
      final grouped = groupModelBy<MapEntry<String, int>>(const [], (file) => file.key);
      expect(grouped.isEmpty, true);
    });

    test('returns empty group with null key', () {
      final grouped = groupModelBy<MapEntry<String, int>>(files, (file) => null);
      expect(grouped.isEmpty, true);
    });

    test('returns empty group with null inputs', () {
      expect(groupModelBy<MapEntry<String, int>>(null, null).isEmpty, true);
      expect(groupModelBy<MapEntry<String, int>>(files, null).isEmpty, true);
      expect(groupModelBy<MapEntry<String, int>>(null, (file) => file.key).isEmpty, true);
    });
  });
}
