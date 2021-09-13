import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeolocatorPlatform extends Mock with MockPlatformInterfaceMixin implements GeolocatorPlatform {}

void main() {
  final geolocator = MockGeolocatorPlatform();
  final client = LocationClient();

  group("LocationClient", () {
    setUp(() {
      GeolocatorPlatform.instance = geolocator;
    });

    group("Fetch location", () {
      test("works normally", () async {
        when(geolocator.getCurrentPosition()).thenAnswer(
          (_) async => Position(
            latitude: 1,
            longitude: 0,
            speed: null,
            accuracy: null,
            speedAccuracy: null,
            heading: null,
            timestamp: null,
            altitude: null,
          ),
        );
        expect(await client.fetchLocation(), LocationData(lat: 1, lng: 0));
        reset(geolocator);
      });

      test("throws when position is null", () async {
        await expectLater(client.fetchLocation(), throwsA(isA<AppException>()));
      });

      test("throws AppException when plugin throws", () async {
        when(geolocator.getCurrentPosition()).thenThrow(PlatformException(code: "error"));
        await expectLater(client.fetchLocation(), throwsA(isA<AppException>()));

        when(geolocator.getCurrentPosition()).thenThrow(PermissionDeniedException(null));
        await expectLater(client.fetchLocation(), throwsA(isA<AppException>()));

        when(geolocator.getCurrentPosition()).thenThrow(LocationServiceDisabledException());
        await expectLater(client.fetchLocation(), throwsA(isA<AppException>()));

        reset(geolocator);
      });
    });

    group("Enable location", () {
      test("works normally when location is enabled", () async {
        when(geolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
        expect(await client.enableLocation(), true);
        reset(geolocator);
      });

      test("works normally when permission is not denied", () async {
        expect(await client.enableLocation(), false);

        when(geolocator.checkPermission()).thenAnswer((_) async => LocationPermission.always);
        expect(await client.enableLocation(), true);

        when(geolocator.checkPermission()).thenAnswer((_) async => LocationPermission.whileInUse);
        expect(await client.enableLocation(), true);

        reset(geolocator);
      });

      group("if permission is denied", () {
        test("works normally when request is granted", () async {
          when(geolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);

          when(geolocator.requestPermission()).thenAnswer((_) async => LocationPermission.always);
          expect(await client.enableLocation(), true);

          when(geolocator.requestPermission()).thenAnswer((_) async => LocationPermission.whileInUse);
          expect(await client.enableLocation(), true);

          reset(geolocator);
        });

        test("works normally when request is denied", () async {
          when(geolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);

          when(geolocator.requestPermission()).thenAnswer((_) async => LocationPermission.denied);
          expect(await client.enableLocation(), false);

          when(geolocator.requestPermission()).thenAnswer((_) async => LocationPermission.deniedForever);
          expect(await client.enableLocation(), false);

          reset(geolocator);
        });
      });

      group("if permission is denied forever", () {
        test("throws when it can/cannot open app/location settings", () async {
          when(geolocator.checkPermission()).thenAnswer((_) async => LocationPermission.deniedForever);

          when(geolocator.openAppSettings()).thenAnswer((_) async => true);
          await expectLater(client.enableLocation(), throwsA(isA<AppException>()));

          when(geolocator.openAppSettings()).thenAnswer((_) async => false);
          when(geolocator.openLocationSettings()).thenAnswer((_) async => true);
          await expectLater(client.enableLocation(), throwsA(isA<AppException>()));

          when(geolocator.openAppSettings()).thenAnswer((_) async => false);
          when(geolocator.openLocationSettings()).thenAnswer((_) async => false);
          await expectLater(client.enableLocation(), throwsA(isA<AppException>()));

          reset(geolocator);
        });
      });
    });
  });
}
