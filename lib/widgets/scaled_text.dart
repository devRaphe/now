import 'package:borome/extensions.dart';
import 'package:flutter/material.dart';

class ScaledText extends StatelessWidget {
  const ScaledText(
    this.data, {
    Key key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  final String data;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style.scale(context),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
