import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirstTimeUserCheck', () {
    test('works normally when true', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{FirstTimeUserCheck.key: true});
      final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
      expect(FirstTimeUserCheck.check(sharedPrefs), true);
      await sharedPrefs.clear();
    });

    test('works normally when false', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{FirstTimeUserCheck.key: false});
      final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
      expect(FirstTimeUserCheck.check(sharedPrefs), false);
      await sharedPrefs.clear();
    });

    test('defaults to true when its first time', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
      expect(FirstTimeUserCheck.check(sharedPrefs), true);
      await sharedPrefs.clear();
    });

    test('persist value to false when its first time', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
      expect(FirstTimeUserCheck.check(sharedPrefs), true);
      expect(sharedPrefs.getBool(FirstTimeUserCheck.key), false);
      await sharedPrefs.clear();
    });
  });
}
