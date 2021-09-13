import 'dart:io' as io;

import 'package:flutter/foundation.dart';

class UploadFileRequestData {
  const UploadFileRequestData({
    @required this.name,
    @required this.description,
    @required this.file,
  });

  final String name;
  final String description;
  final io.File file;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'UploadFileRequestData{name: $name, description: $description, file: $file}';
  }
}
