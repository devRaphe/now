import 'package:borome/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "TheAmazingAppIcon",
      child: Container(
        constraints: BoxConstraints.tight(Size.square(52)),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image(image: AppImages.icon, fit: BoxFit.scaleDown),
      ),
    );
  }
}
