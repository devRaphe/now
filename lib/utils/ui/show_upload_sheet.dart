import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'platform_action_sheet.dart';

enum UploadType {
  camera,
  image,
  pdf,
}

Future<UploadType> showUploadSheet(BuildContext context) {
  return PlatformActionSheet.show(
    context: context,
    actions: [
      ActionSheetAction(
        text: "Camera",
        onPressed: () => Navigator.pop(context, UploadType.camera),
      ),
      ActionSheetAction(
        text: "Gallery",
        onPressed: () => Navigator.pop(context, UploadType.image),
      ),
      ActionSheetAction(
        text: "PDF",
        onPressed: () => Navigator.pop(context, UploadType.pdf),
      ),
      ActionSheetAction(
        text: "Cancel",
        onPressed: () => Navigator.pop(context),
        isCancel: true,
        defaultAction: true,
      )
    ],
  );
}

Future<File> pickFile(UploadType type) async {
  switch (type) {
    case UploadType.camera:
      final result = await ImagePicker().getImage(source: ImageSource.camera);
      return File(result.path);
    case UploadType.pdf:
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);
      return File(result.files.first.path);
    case UploadType.image:
    default:
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      return File(result.files.first.path);
  }
}
