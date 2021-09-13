import 'dart:io' as io;

import 'package:borome/constants.dart';
import 'package:borome/registry.dart';
import 'package:borome/services.dart';
import 'package:borome/services/camera_client.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:camera/camera.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'file_controller.dart';

abstract class CameraViewState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  CameraViewState() : _client = Registry.di.camera;

  CameraController controller;
  final CameraClient _client;

  bool get hasFrontCamera => _client.hasFrontCamera;

  @protected
  FileController get fileController;

  @protected
  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final textStyle = ThemeProvider.of(context).bodyBold;
    if (_client.isEmpty) {
      return Center(child: Text('No cameras available', style: textStyle));
    }
    if (controller == null || !controller.value.isInitialized) {
      return Center(child: Text('Hang on', style: textStyle));
    }

    return builder(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_client.isNotEmpty) {
        _onNewCameraSelected(_client.frontCamera ?? _client.first);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high, enableAudio: true);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        _showErrorMessage(controller.value.errorDescription);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e, st) {
      _showException(AppException(e.description), st);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<io.File> _takePicture() async {
    if (!(controller?.value?.isInitialized ?? false)) {
      _showErrorMessage('Select a camera first.');
      return null;
    }
    final filePath = await _createFilePath('Pictures', 'jpg');

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e, st) {
      _showException(AppException(e.description), st);
      return null;
    }
    return io.File(filePath);
  }

  void reset() {
    fileController.reset();
  }

  void takePicture() {
    _takePicture().then((file) {
      if (mounted && file != null) {
        HapticFeedback.lightImpact();
        fileController.update(file, controller.value.aspectRatio);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        _onNewCameraSelected(controller.description);
      }
    }
  }

  void _showException(AppException e, StackTrace stackTrace) {
    AppLog.e(e, stackTrace);
    _showErrorMessage(errorToString(e));
  }

  void _showErrorMessage(String message) {
    AppSnackBar.of(context).error(message);
  }
}

String _timestamp() => clock.now().millisecondsSinceEpoch.toString();

Future<String> _createFilePath(String category, String ext) async {
  final io.Directory extDir = await getApplicationDocumentsDirectory();
  final String dirPath = '${extDir.path}/$category/${AppStrings.appName}';
  await io.Directory(dirPath).create(recursive: true);
  return '$dirPath/${_timestamp()}.$ext';
}
