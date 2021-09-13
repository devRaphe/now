import 'package:borome/constants.dart';
import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class LabelHintWrapper extends StatelessWidget {
  const LabelHintWrapper({
    Key key,
    @required this.label,
    @required this.child,
    this.hint,
  }) : super(key: key);

  final String label;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget labelWidget = Text(label, style: ThemeProvider.of(context).label);

    if (hint != null) {
      labelWidget = TouchableOpacity(
        minHeight: 0,
        child: Row(
          children: <Widget>[
            Icon(Icons.info_outline, color: AppColors.primary, size: 14),
            const ScaledBox.horizontal(6),
            labelWidget,
          ],
        ),
        onPressed: () async {
          await showHintDialog(context, hint: hint, label: label);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        labelWidget,
        const ScaledBox.vertical(6),
        child,
      ],
    );
  }
}
