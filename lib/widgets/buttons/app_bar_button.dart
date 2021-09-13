import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({Key key, @required this.title, this.onPressed}) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      padding: EdgeInsets.symmetric(horizontal: context.scale(20)),
      child: Text(
        title,
        style: ThemeProvider.of(context)
            .body1
            .copyWith(color: AppColors.dark, fontWeight: AppStyle.semibold, height: 1.24, letterSpacing: 1.25),
      ),
      onPressed: onPressed,
    );
  }
}
