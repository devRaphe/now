import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Generate cached id', () {
    test('works normally', () async {
      const key = "key";
      final generator = generateCachedId(duration: Duration(seconds: 1));
      final id = generator(key);
      for (int i = 0; i < Duration.microsecondsPerSecond; i++) {
        expect(generator(key), id);
      }
    });

    test('would generate new ids after expiry', () async {
      const key = "key";
      final generator = generateCachedId(duration: Duration(seconds: 1));
      final id1 = generator(key);
      await Future<void>.delayed(Duration(seconds: 1));
      final id2 = generator(key);
      expect(id1 == id2, false);
    });

    test('would generate new ids for different keys', () async {
      const key = "key";
      final generator = generateCachedId(duration: Duration(microseconds: 10));
      final ids = <String>[];
      for (int i = 0; i < 10; i++) {
        ids.add(generator("$key-$i"));
        if (i == 0) {
          continue;
        }
        expect(ids[i - 1] == ids[i], false);
      }
    });
  });
}
