import 'dart:io' as io;

import 'package:flutter/foundation.dart';

class FileController extends ValueNotifier<_Data> {
  FileController({@required this.onAfterUpdate}) : super(null);

  final VoidCallback onAfterUpdate;

  void update(io.File file, double aspectRatio) {
    value = _Data(file, aspectRatio);
    onAfterUpdate();
  }

  void reset() {
    value = null;
  }

  bool get isEmpty => value == null;

  io.File get file => value?.file;

  double get aspectRatio => value?.aspectRatio;
}

class _Data {
  _Data(this.file, this.aspectRatio);

  io.File file;
  double aspectRatio;
}
