import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';

const durationMS = 1;

Future<void> waitForTimer(int milliseconds) => Future<void>(() {}).then<void>(
      (_) => Future<void>.delayed(Duration(milliseconds: milliseconds + 1)),
    );

void main() {
  group('Debounce', () {
    test('works normally', () async {
      final List<String> record = [];
      final target = (String arg) => record.add(arg);
      final callback = () => debounce(durationMS, target, <dynamic>["a"]);
      callback();
      callback();
      callback();
      callback();
      expect(record.length, 0);
      await waitForTimer(durationMS);
      expect(record.length, 1);
      expect(record.first, "a");
    });

    test('gets multiple callbacks after subsequent delays', () async {
      final List<String> record = [];
      final target = (String arg) => record.add(arg);
      final callback = () => debounce(durationMS, target, <dynamic>["a"]);
      callback();
      await waitForTimer(durationMS);
      callback();
      await waitForTimer(durationMS);
      callback();
      await waitForTimer(durationMS);
      expect(record.length, 3);
    });
  });
}
