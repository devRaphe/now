import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class CountDownTimer extends StatelessWidget {
  const CountDownTimer({Key key, this.maxSeconds = 30, this.onEnd}) : super(key: key);

  final int maxSeconds;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: maxSeconds + 1, end: 0),
      duration: Duration(seconds: maxSeconds),
      onEnd: onEnd,
      builder: (_, int value, __) {
        return RichText(
          key: ValueKey(value),
          text: TextSpan(
            text: "Time left  ",
            children: [
              TextSpan(
                text: "00:" + value.toString().padLeft(2, "0"),
                style: theme.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ],
            style: theme.body1,
          ),
        );
      },
    );
  }
}
