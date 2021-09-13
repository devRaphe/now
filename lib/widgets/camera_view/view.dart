import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'file_controller.dart';
import 'view_state.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key key,
    @required this.controller,
    @required this.scale,
  }) : super(key: key);

  final FileController controller;
  final double scale;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends CameraViewState<CameraView> {
  final imageKey = ValueKey("preview");
  static final loadingSpinner = LoadingSpinner.circle(color: AppColors.white, size: 16);

  @override
  FileController get fileController => widget.controller;

  @override
  Widget builder(BuildContext context) {
    return ClipPath(
      clipper: _OvalClip(),
      child: Center(
        child: Transform.scale(
          scale: widget.scale,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: AnimatedBuilder(
              animation: fileController,
              builder: (context, snapshot) => AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: fileController.isEmpty
                    ? CameraPreview(controller)
                    : Image.file(
                        fileController.file,
                        key: imageKey,
                        gaplessPlayback: true,
                        frameBuilder: (_a, child, int frame, _b) => AnimatedSwitcher(
                          child: frame == null ? loadingSpinner : child,
                          duration: Duration(seconds: 1),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OvalClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final rect = Offset.zero & size;
    return Path.combine(
      PathOperation.intersect,
      Path()..addRect(rect),
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(12))),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
