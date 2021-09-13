import 'package:borome/constants.dart';
import 'package:borome/extensions.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class RadioSwitchFormField extends StatelessWidget {
  const RadioSwitchFormField({
    Key key,
    this.initialValue = 0,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onSaved,
    this.label,
    this.enabled = true,
    this.titles = const ["Yes", "No"],
    this.validator,
  }) : super(key: key);

  final FormFieldSetter<int> onSaved;
  final FormFieldValidator<int> validator;
  final int initialValue;
  final Widget label;
  final bool enabled;
  final List<String> titles;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DefaultTextStyle(child: label, style: ThemeProvider.of(context).label),
        const ScaledBox.vertical(5),
        FormField<int>(
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          validator: validator,
          enabled: enabled,
          onSaved: onSaved,
          builder: (FormFieldState<int> field) => LayoutBuilder(
            builder: (context, constraint) {
              final spacing = context.scale(20);
              final minWidth = (constraint.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing / 2,
                children: <Widget>[
                  for (int i = 0; i < titles.length; i++)
                    _ChoiceButton(
                      enabled: enabled,
                      isActive: field.value == i,
                      minWidth: minWidth,
                      child: Text(titles[i]),
                      onPressed: () => field.didChange(i),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    Key key,
    this.enabled = true,
    this.isActive = false,
    this.minWidth = 0,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  final bool enabled;
  final bool isActive;
  final double minWidth;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.white : kTextBaseColor;
    final height = context.scaleY(52);
    final backgroundColor = isActive ? AppColors.primary : AppColors.dark.shade50;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height, maxWidth: minWidth),
      child: TextButton(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              left: 0,
              right: null,
              child: Icon(Icons.check_circle_rounded, color: color),
            ),
            Center(
              child: DefaultTextStyle(
                child: child,
                style: ThemeProvider.of(context).subhead3.copyWith(color: color),
              ),
            ),
          ],
        ),
        style: TextButton.styleFrom(
          primary: color,
          minimumSize: Size(minWidth, height),
          backgroundColor: onPressed != null ? backgroundColor : backgroundColor.withOpacity(.75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(12).scale(context),
        ),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
