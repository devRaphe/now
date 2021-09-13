import 'package:borome/mixins/dismiss_keyboard_mixin.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class FakeTextFormField<T> extends StatefulWidget {
  const FakeTextFormField({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.child,
    this.decoration = const InputDecoration(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final ValueChanged<FormFieldState<T>> onTap;
  final T initialValue;
  final Widget child;
  final InputDecoration decoration;
  final AutovalidateMode autovalidateMode;

  @override
  FakeTextFormFieldState<T> createState() => FakeTextFormFieldState<T>();
}

class FakeTextFormFieldState<T> extends State<FakeTextFormField<T>> with DismissKeyboardMixin {
  final GlobalKey<FormFieldState> key = GlobalKey<FormFieldState>();

  bool get isEnabled => widget.onTap != null;

  void reset() {
    key.currentState.reset();
  }

  void clear() {
    key.currentState.didChange(null);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = ThemeProvider.of(context);
    return FormField<T>(
      key: key,
      enabled: isEnabled,
      initialValue: widget.initialValue != null ? widget.initialValue : null,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<T> field) {
        final effectiveDecoration = widget.decoration
            .applyDefaults(Theme.of(context).inputDecorationTheme)
            .copyWith(errorText: field.errorText);

        return InkWell(
          onTap: isEnabled ? _onTap(field) : null,
          child: InputDecorator(
            decoration: effectiveDecoration,
            child: DefaultTextStyle(
              style: _buildTextStyle(field.value, _theme),
              child: widget.child ?? Text(_buildTextContent(field.value)),
            ),
          ),
        );
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }

  VoidCallback _onTap(FormFieldState<T> field) {
    return () {
      closeKeyboard();
      widget.onTap(field);
    };
  }

  TextStyle _buildTextStyle(T value, ThemeProvider theme) {
    if (!isEnabled) {
      return theme.textfieldLabel.copyWith(height: 1.5);
    }

    if ((value != null && value is! List && value is! String) ||
        (value is List && value.isNotEmpty) ||
        (value is String && value.isNotEmpty)) {
      return theme.textfield.copyWith(height: 1.5);
    }

    return theme.textfieldLabel.copyWith(height: 1.5);
  }

  String _buildTextContent(T value) {
    if (value == null) {
      return widget.decoration.hintText;
    }
    if (value is List) {
      return value.isNotEmpty ? "Successfully Added!" : widget.decoration.hintText;
    }
    if (value is String) {
      return value.isNotEmpty ? value.toString() : widget.decoration.hintText;
    }
    return value.toString();
  }
}
