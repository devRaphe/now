import 'package:borome/constants.dart';
import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  factory LoadingSpinner.circle({Key key, double size = 32, double strokeWidth = 4, Color color = AppColors.primary}) {
    return LoadingSpinner._(
      key: key,
      size: Size.square(size),
      color: color,
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(color), strokeWidth: strokeWidth),
    );
  }

  factory LoadingSpinner.linear({Key key, double size = 3, Color color = AppColors.primary}) {
    return LoadingSpinner._(
      key: key,
      size: Size.fromHeight(size),
      color: color,
      child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(color)),
    );
  }

  const LoadingSpinner._({Key key, @required this.size, @required this.color, @required this.child}) : super(key: key);

  final Color color;
  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(size: size, child: child);
}
