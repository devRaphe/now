import 'package:borome/constants.dart';
import 'package:borome/services.dart';
import 'package:borome/services/permissions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:platform/platform.dart';

class MockPermissionHandler extends Mock implements PermissionHandlerPlatform {}

class MockLocationClient extends Mock implements LocationClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final locationClient = MockLocationClient();

  group("Permissions", () {
    group("Request", () {
      test("works normally when all permissions granted", () async {
        when(locationClient.enableLocation()).thenAnswer((_) async => true);

        final handler = MockPermissionHandler();
        final permission = Permissions(locationClient, handler);
        toggleRequestPermission(handler, allPermissionsGranted);

        final result = await permission.request();
        expect(result.isOk, true);

        reset(locationClient);
      });

      test("returns error when location disabled", () async {
        when(locationClient.enableLocation()).thenAnswer((_) async => false);

        final handler = MockPermissionHandler();
        final permission = Permissions(locationClient, handler);
        toggleRequestPermission(handler, allPermissionsGranted);

        final result = await permission.request();
        expect(result.isOk, false);
        expect(result.message, AppStrings.notEnoughPermissions);

        reset(locationClient);
      });

      test("handles error gracefully from location client", () async {
        when(locationClient.enableLocation()).thenThrow(AppException("We"));

        final handler = MockPermissionHandler();
        final permission = Permissions(locationClient, handler);
        toggleRequestPermission(handler, allPermissionsGranted);

        final result = await permission.request();
        expect(result.isOk, false);
        expect(result.message, "We");

        reset(locationClient);
      });

      test("returns error when any permission not granted", () async {
        when(locationClient.enableLocation()).thenAnswer((_) async => true);

        final handler = MockPermissionHandler();
        final permission = Permissions(locationClient, handler);
        toggleRequestPermission(handler, allPermissionsGranted..replaceRange(0, 1, [PermissionStatus.denied]));

        final result = await permission.request();
        expect(result.isOk, false);
        expect(result.message, AppStrings.notEnoughPermissions);

        reset(locationClient);
      });
    });

    group('Storage', () {
      group('works normally for android', () {
        final platform = FakePlatform(operatingSystem: "android");

        test('when status is enabled', () async {
          final handler = MockPermissionHandler();
          final permission = Permissions(locationClient, handler);
          togglePermissions(handler, [Permission.storage], [PermissionStatus.granted]);

          final result = await permission.checkStorage(platform);
          expect(result.isOk, true);

          reset(locationClient);
        });

        test('when status is denied', () async {
          final handler = MockPermissionHandler();
          final permission = Permissions(locationClient, handler);
          togglePermissions(handler, [Permission.storage], [PermissionStatus.denied]);

          final result = await permission.checkStorage(platform);
          expect(result.isOk, false);
          expect(result.message, AppStrings.notEnoughPermissions);

          reset(locationClient);
        });

        test('when status is disabled', () async {
          final handler = MockPermissionHandler();
          final permission = Permissions(locationClient, handler);

          final result = await permission.checkStorage(platform);
          expect(result.isOk, false);
          expect(result.message, AppStrings.notEnoughPermissions);

          reset(locationClient);
        });
      });

      test('ignores permission checking on iOS', () async {
        final permission = Permissions(locationClient, MockPermissionHandler());

        final result = await permission.checkStorage(FakePlatform(operatingSystem: "ios"));
        expect(result.isOk, true);

        reset(locationClient);
      });
    });
  });
}

void toggleRequestPermission(PermissionHandlerPlatform handler, List<PermissionStatus> status) {
  togglePermissions(handler, Permissions.permissions, status);
}

void togglePermissions(PermissionHandlerPlatform handler, List<Permission> groups, List<PermissionStatus> status) {
  for (int count = 0; count < groups.length; count++) {
    final group = groups[count];
    when(handler.checkPermissionStatus(group)).thenAnswer((_) async => status[count]);
    when(handler.requestPermissions([group])).thenAnswer(
      (_) async => <Permission, PermissionStatus>{group: status[count]},
    );
  }
}

final allPermissionsGranted = List.filled(Permissions.permissions.length, PermissionStatus.granted).toList();
final onePermissionGranted = List<PermissionStatus>.generate(
    Permissions.permissions.length, (i) => i == 0 ? PermissionStatus.granted : PermissionStatus.denied).toList();
