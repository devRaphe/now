import 'package:borome/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

const _deviceInfoChannel = MethodChannel('plugins.flutter.io/device_info');
const _packageInfoChannel = MethodChannel('plugins.flutter.io/package_info');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("AppDeviceInfo", () {
    setUpAll(() {
      _packageInfoChannel.setMockMethodCallHandler((call) async {
        if (call.method == "getAll") {
          return <String, String>{"appName": "App"};
        }
      });
      _deviceInfoChannel.setMockMethodCallHandler((call) async {
        if (call.method == "getAndroidDeviceInfo") {
          return <String, String>{"model": "Nokia 2"};
        }
        if (call.method == "getIosDeviceInfo") {
          return <String, String>{"name": "iPhone XS Max", "systemName": "iPadOS"};
        }
      });
    });

    tearDownAll(() {
      _packageInfoChannel.setMockMethodCallHandler(null);
      _deviceInfoChannel.setMockMethodCallHandler(null);
    });

    test("works normally for android", () async {
      final info = await AppDeviceInfo.initialize(FakePlatform(operatingSystem: "android"));

      expect(info.appName, "App");
      expect(info.os, "Android");
      expect(info.model, "Nokia 2");

      final infoMap = info.toMap();
      expect(infoMap.containsKey("appName"), true);
      expect(infoMap.containsKey("packageName"), true);
    });

    test("works normally for ios", () async {
      final info = await AppDeviceInfo.initialize(FakePlatform(operatingSystem: "ios"));

      expect(info.appName, "App");
      expect(info.os, "iPadOS");
      expect(info.model, "iPhone XS Max");

      final infoMap = info.toMap();
      expect(infoMap.containsKey("appName"), true);
      expect(infoMap.containsKey("packageName"), true);
    });
  });
}
