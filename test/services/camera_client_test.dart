import 'package:borome/services/camera_client.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CameraClient", () {
    test("works normally", () {
      final cameras = [
        CameraDescription(lensDirection: CameraLensDirection.back),
        CameraDescription(lensDirection: CameraLensDirection.front),
        CameraDescription(lensDirection: CameraLensDirection.back),
      ];
      final client = CameraClient(cameras);
      expect(client.length, 3);
      expect(client.isEmpty, false);
      expect(client.isNotEmpty, true);
      expect(client.hasFrontCamera, true);
      expect(client.frontCamera, cameras[1]);
      expect(client.first, cameras.first);
    });

    test("works normally with empty cameras", () {
      final client = CameraClient([]);
      expect(client.length, 0);
      expect(client.isEmpty, true);
      expect(client.isNotEmpty, false);
      expect(client.hasFrontCamera, false);
      expect(client.frontCamera, null);
      expect(client.first, null);
    });

    test("works normally without front camera", () {
      final cameras = [
        CameraDescription(lensDirection: CameraLensDirection.back),
      ];
      final client = CameraClient(cameras);
      expect(client.length, 1);
      expect(client.isEmpty, false);
      expect(client.isNotEmpty, true);
      expect(client.hasFrontCamera, false);
      expect(client.frontCamera, null);
      expect(client.first, cameras.first);
    });

    test("would not work with null cameras", () {
      expect(() => CameraClient(null), throwsAssertionError);
    });
  });
}
