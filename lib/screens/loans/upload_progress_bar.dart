import 'dart:ui' as ui;

import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class UploadProgressBar extends StatefulWidget {
  @override
  _UploadProgressBarState createState() => _UploadProgressBarState();
}

class _UploadProgressBarState extends State<UploadProgressBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.scaleY(12),
      child: CustomPaint(
        painter: _ProgressPainter(animation: _controller),
        child: SizedBox.expand(),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter({@required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(12));
    canvas.clipRRect(shape);

    canvas.drawRRect(shape, Paint()..color = AppColors.primary);

    final value = interpolate(outputMax: size.width)(animation.value);
    final thumbWidth = size.width / 5;
    final thumbRect = Rect.fromLTWH(value - (thumbWidth / 2), 0, thumbWidth, size.height);
    canvas.drawRect(
      thumbRect,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(thumbRect.left, 0),
          Offset(thumbRect.right, 0),
          [Color(0x00FFFFFF), Colors.white38, Color(0x00FFFFFF)],
          [0, .5, 1],
        )
        ..blendMode = BlendMode.screen,
    );

    canvas.clipRRect(RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(12)));
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) => oldDelegate.animation != animation;
}
