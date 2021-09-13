import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/extensions.dart';
import 'package:borome/registry.dart';
import 'package:borome/screens/profile/widgets/add_file_description_dialog.dart';
import 'package:borome/screens/profile/widgets/file_item.dart';
import 'package:borome/store.dart';
import 'package:borome/utils.dart';
import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';

class FileItemGroup extends StatefulWidget {
  const FileItemGroup({
    Key key,
    @required this.name,
    @required this.files,
  }) : super(key: key);

  final String name;
  final List<FileModel> files;

  @override
  _FileItemGroupState createState() => _FileItemGroupState();
}

class _FileItemGroupState extends State<FileItemGroup> {
  final platform = LocalPlatform();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 54).scale(context),
      child: LayoutBuilder(builder: (context, constraint) {
        final spacing = context.scale(20);
        final size = Size.square((constraint.maxWidth - spacing) / 2);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing / 2,
          children: <Widget>[
            for (int i = 0; i < widget.files.length; i++)
              FileItem(
                size: size,
                icon: AppIcons.file,
                title: Text(
                  widget.files[i].description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () => onDownloadFile(widget.files[i].url),
                onDelete: () => onDeleteFile(widget.files[i].id, widget.files.length),
              ),
            FileItem(
              size: size,
              color: kTextBaseColor,
              icon: AppIcons.add_file,
              title: const Text("Upload File"),
              onPressed: onUploadFile,
            ),
          ],
        );
      }),
    );
  }

  void onDownloadFile(String url) async {
    await Registry.di.permissions.checkStorage(platform);

    final choice = await showConfirmDialog(context, "Do you wish to download this file?");

    if (choice != true) {
      return;
    }

    AppSnackBar.of(context).info("Downloading...", duration: Duration(seconds: 2));

    final _localPath =
        (platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory()).path +
            platform.pathSeparator +
            AppStrings.appName;

    await Directory(_localPath).create();

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
      fileName: clock.now().millisecondsSinceEpoch.toString() + Uri.parse(url).path.split("/").last,
    );

    await FlutterDownloader.open(taskId: taskId);
  }

  void onDeleteFile(int id, int count) async {
    final choice = await showConfirmDialog(context, "Do you wish to delete this file?");

    if (choice != true) {
      return;
    }

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.auth.deleteFile(id);
      if (!mounted) {
        return;
      }

      context.dispatchAction(UserActions.fetch());
      if (count == 1) {
        Navigator.pop(context);
        AppSnackBar.of(context).hide();
      } else {
        AppSnackBar.of(context).success(message);
      }
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }

  void onUploadFile() async {
    final choice = await showUploadSheet(context);

    if (choice == null) {
      return;
    }

    File file;
    try {
      file = await pickFile(choice);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error("An error occurred while selecting the file");
      return;
    }

    if (file == null) {
      return;
    }

    final description = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddFileDescriptionDialog(),
    );

    if (description == null) {
      return;
    }

    final request = UploadFileRequestData(
      name: widget.name,
      description: description,
      file: file,
    );

    AppSnackBar.of(context).loading();
    try {
      final message = await Registry.di.repository.auth.uploadFile(request);
      if (!mounted) {
        return;
      }

      context.dispatchAction(UserActions.fetch());
      AppSnackBar.of(context).success(message);
    } catch (e, st) {
      AppLog.e(e, st);
      AppSnackBar.of(context).error(errorToString(e));
    }
  }
}
