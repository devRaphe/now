import 'package:camera/camera.dart';

class CameraClient {
  CameraClient(this._cameras) : assert(_cameras != null);

  final List<CameraDescription> _cameras;

  int get length => _cameras?.length ?? 0;

  CameraDescription get first => isNotEmpty ? _cameras.first : null;

  bool get isEmpty => length == 0;

  bool get isNotEmpty => length > 0;

  bool get hasFrontCamera => frontCamera != null;

  CameraDescription get frontCamera {
    return _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => null,
    );
  }
}
