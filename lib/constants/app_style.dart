import 'package:borome/constants.dart';
import 'package:flutter/material.dart';

const Color kHintColor = Color(0xFFAAAAAA);
const Color kBorderSideColor = Color(0x66D1D1D1);
final Color kBorderSideErrorColor = AppColors.secondaryAccent.shade900;
const Color kTextBaseColor = Color(0xFFA9A9A9);

const double kButtonHeight = 66.0;

class AppBorderSide extends BorderSide {
  const AppBorderSide({Color color, BorderStyle style, double width})
      : super(color: color ?? kBorderSideColor, style: style ?? BorderStyle.solid, width: width ?? 1.0);
}

class AppStyle extends TextStyle {
  const AppStyle({double fontSize, FontWeight fontWeight, Color color})
      : super(
          inherit: false,
          color: color ?? kTextBaseColor,
          fontFamily: AppFonts.base,
          fontSize: fontSize,
          fontWeight: fontWeight ?? AppStyle.regular,
          textBaseline: TextBaseline.alphabetic,
        );

  static const FontWeight thin = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w800;
}

class AppFont extends AppStyle {
  const AppFont.size(double size) : super(fontSize: size);

  const AppFont.thin(double size, [Color color]) : super(fontSize: size, fontWeight: AppStyle.thin, color: color);

  const AppFont.light(double size, [Color color]) : super(fontSize: size, fontWeight: AppStyle.light, color: color);

  const AppFont.regular(double size, [Color color]) : super(fontSize: size, color: color);

  const AppFont.medium(double size, [Color color]) : super(fontSize: size, fontWeight: AppStyle.medium, color: color);

  const AppFont.semibold(double size, [Color color])
      : super(fontSize: size, fontWeight: AppStyle.semibold, color: color);

  const AppFont.bold(double size, [Color color]) : super(fontSize: size, fontWeight: AppStyle.bold, color: color);
}
