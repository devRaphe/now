import 'dart:io' as io;
import 'dart:math' as math;

import 'package:borome/registry.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

extension on num {
  num coerce(num min, num max) => math.max(math.min(this, max), min);
}

class ProfilePhotoFormView extends StatefulWidget {
  const ProfilePhotoFormView({
    Key key,
    @required this.onSaved,
    this.buttonCaption,
  }) : super(key: key);

  final ValueChanged<io.File> onSaved;
  final String buttonCaption;

  @override
  ProfilePhotoFormViewState createState() => ProfilePhotoFormViewState();
}

class ProfilePhotoFormViewState extends State<ProfilePhotoFormView> {
  final cameraKey = GlobalKey<CameraViewState<CameraView>>();
  FileController _fileController;

  @override
  void initState() {
    super.initState();
    _fileController = FileController(onAfterUpdate: () {});
  }

  @override
  void dispose() {
    _fileController.dispose();
    super.dispose();
  }

  void reset() {
    _fileController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraint) => ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraint.tighten().smallest.width * .9),
            child: CameraView(
              key: cameraKey,
              scale: (1 / MediaQuery.of(context).size.aspectRatio).coerce(1.9, 2.1),
              controller: _fileController,
            ),
          ),
        ),
        ScaledBox.vertical(32),
        AnimatedBuilder(
          animation: _fileController,
          builder: (context, child) {
            if (!_fileController.isEmpty) {
              return FilledButton(
                onPressed: handleSubmit,
                child: Text(widget.buttonCaption ?? "Next"),
              );
            }

            return FilledButton(
              onPressed: Registry.di.session.isMock ? handleSubmit : () => cameraKey.currentState.takePicture(),
              child: Text("Capture"),
            );
          },
        ),
        const ScaledBox.vertical(4),
        AnimatedBuilder(
          animation: _fileController,
          builder: (context, child) {
            if (!_fileController.isEmpty) {
              return TouchableOpacity(
                child: Text("Retake Photo"),
                onPressed: () => cameraKey.currentState.reset(),
              );
            }

            return SizedBox();
          },
        ),
        const ScaledBox.vertical(16),
      ],
    );
  }

  void handleSubmit() async {
    widget.onSaved(_fileController.file);
  }
}
