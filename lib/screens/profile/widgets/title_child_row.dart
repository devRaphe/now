import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class TitleChildRow extends StatelessWidget {
  const TitleChildRow({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context).subhead3;
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: theme)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: DefaultTextStyle(
              style: theme.copyWith(color: AppColors.dark),
              textAlign: TextAlign.end,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
