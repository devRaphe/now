import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    Key key,
    this.focusNode,
    this.textInputAction,
    this.initialValue,
    this.onEditingComplete,
    this.onChanged,
    this.onSaved,
    this.autovalidate = false,
    this.decoration = const InputDecoration(),
    this.validator,
    this.controller,
  })  : fieldKey = key,
        super();

  final Key fieldKey;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final String initialValue;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSaved;
  final FormFieldValidator<String> validator;
  final InputDecoration decoration;
  final bool autovalidate;
  final TextEditingController controller;

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      initialValue: widget.initialValue,
      controller: widget.controller,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: TextCapitalization.none,
      validator: widget.validator,
      decoration: widget.decoration.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureText = !_obscureText),
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
          ),
    );
  }
}
