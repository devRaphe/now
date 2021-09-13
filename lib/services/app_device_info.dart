import 'package:borome/utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:platform/platform.dart';

import 'exceptions.dart';

class AppDeviceInfo {
  AppDeviceInfo._({@required _DeviceInfo device, @required PackageInfo package})
      : _device = device,
        _package = package;

  final PackageInfo _package;
  final _DeviceInfo _device;

  @visibleForTesting
  static AppDeviceInfo mock() {
    return AppDeviceInfo._(
      package: PackageInfo(appName: "App", buildNumber: "1", packageName: "com.example", version: "1.0.0"),
      device: _DeviceInfo(
        id: "1234-56789-1234-5678-9876",
        version: "14.0",
        os: "ios",
        brand: "iphone",
        isPhysicalDevice: true,
        model: "12",
        sdk: "x84_64",
      ),
    );
  }

  static Future<AppDeviceInfo> initialize([Platform platform = const LocalPlatform()]) async {
    try {
      return AppDeviceInfo._(
        package: await PackageInfo.fromPlatform(),
        device: await _DeviceInfo.initialize(DeviceInfoPlugin(), platform),
      );
    } catch (e, st) {
      AppLog.e(e, st);
      throw AppException("Unable to fetch device and package information");
    }
  }

  String get appName => _package?.appName;

  String get buildNumber => _package?.buildNumber;

  String get packageName => _package?.packageName;

  String get deviceId => _device.id;

  String get os => _device.os;

  String get brand => _device.brand;

  String get model => _device.model;

  String get version => _device.version;

  String get sdk => _device.sdk;

  bool get isPhysicalDevice => _device.isPhysicalDevice;

  Map<String, String> toMap() {
    return {
      'appName': appName,
      'buildNumber': buildNumber,
      'deviceId': deviceId,
      'isPhysicalDevice': '$isPhysicalDevice',
      'packageName': packageName,
      'os': os,
      'brand': brand,
      'model': model,
      'version': version,
      'sdk': sdk,
    };
  }
}

class _DeviceInfo {
  _DeviceInfo({
    @required this.id,
    @required this.isPhysicalDevice,
    @required this.os,
    @required this.brand,
    @required this.model,
    @required this.version,
    @required this.sdk,
  });

  static Future<_DeviceInfo> initialize(DeviceInfoPlugin info, Platform platform) async {
    final android = platform.isAndroid ? await info.androidInfo : null;
    final ios = platform.isIOS ? await info.iosInfo : null;
    return _DeviceInfo(
      id: platform.isAndroid ? android.androidId : ios.identifierForVendor,
      isPhysicalDevice: platform.isAndroid ? android.isPhysicalDevice : ios.isPhysicalDevice,
      os: platform.isAndroid ? "Android" : ios.systemName,
      brand: platform.isAndroid ? android.brand : ios.model,
      model: platform.isAndroid ? android.model : ios.name,
      version: platform.isAndroid ? android.version?.release : ios.systemVersion,
      sdk: platform.isAndroid ? '${android.version?.sdkInt}' : ios.utsname?.machine,
    );
  }

  final String id;
  final bool isPhysicalDevice;
  final String os;
  final String brand;
  final String model;
  final String version;
  final String sdk;
}
