import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

Future<void> showHintDialog(
  BuildContext context, {
  String hint,
  Widget child,
  @required String label,
}) {
  assert(
    !(hint == null && child == null) || (hint != null && child != null),
    "Either hint or child has to be provided",
  );
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _HintDialog(label: label, hint: hint, child: child),
  );
}

class _HintDialog extends StatelessWidget {
  const _HintDialog({
    Key key,
    @required this.label,
    this.hint,
    this.child,
  }) : super(key: key);

  final String label;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Center(
      child: Material(
        elevation: 1,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.scale(312)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ScaledBox.vertical(14),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.title.copyWith(fontWeight: AppStyle.semibold, height: 1.22, color: AppColors.primary),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20).scale(context),
                child: child ??
                    Text(
                      hint,
                      textAlign: TextAlign.center,
                      style: theme.textfield.copyWith(height: 1.22, color: AppColors.dark),
                    ),
              ),
              const Divider(height: 0),
              TouchableOpacity(
                child: Text("CLOSE", style: theme.subhead1Semi.copyWith(letterSpacing: 1.1)),
                color: kTextBaseColor,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
