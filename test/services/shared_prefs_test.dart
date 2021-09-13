import 'package:borome/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, dynamic>{});
  const key = "key";

  group("SharedPrefs", () {
    SharedPrefs sharedPrefs;

    setUp(() async {
      sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
    });

    tearDown(() async {
      await sharedPrefs.clear();
      sharedPrefs = null;
    });

    test("Bool", () async {
      await sharedPrefs.setBool(key, true);
      expect(sharedPrefs.getBool(key), true);
      await sharedPrefs.setBool(key, false);
      expect(sharedPrefs.getBool(key), false);
    });

    test("String", () async {
      await sharedPrefs.setString(key, "true");
      expect(sharedPrefs.getString(key), "true");
      await sharedPrefs.setString(key, "false");
      expect(sharedPrefs.getString(key), "false");
    });

    test("Int", () async {
      await sharedPrefs.setInt(key, 1);
      expect(sharedPrefs.getInt(key), 1);
      await sharedPrefs.setInt(key, 0);
      expect(sharedPrefs.getInt(key), 0);
    });

    test("Map", () async {
      final a = <String, bool>{"a": true};
      await sharedPrefs.setMap(key, a);
      expect(sharedPrefs.getMap(key), a);
      final b = <String, bool>{"b": false};
      await sharedPrefs.setMap(key, b);
      expect(sharedPrefs.getMap(key), b);
    });

    test("contains and remove", () async {
      expect(sharedPrefs.contains(key), false);
      await sharedPrefs.setBool(key, true);
      expect(sharedPrefs.contains(key), true);
      await sharedPrefs.remove(key);
      expect(sharedPrefs.contains(key), false);
    });

    test("clear", () async {
      const keys = ["a", "b", "c"];
      for (final key in keys) {
        expect(sharedPrefs.contains(key), false);
      }
      for (final key in keys) {
        await sharedPrefs.setBool(key, true);
      }
      for (final key in keys) {
        expect(sharedPrefs.contains(key), true);
      }
      await sharedPrefs.clear();
      for (final key in keys) {
        expect(sharedPrefs.contains(key), false);
      }
    });
  });
}
