import 'package:borome/constants.dart';
import 'package:flutter/material.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({Key key, this.color, this.onPressed}) : super(key: key);

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: IconTheme.of(context).size,
      icon: const Icon(AppIcons.cancel),
      color: color ?? AppColors.dark,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onPressed ?? () => Navigator.maybePop(context),
    );
  }
}
