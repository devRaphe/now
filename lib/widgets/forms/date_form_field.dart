import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'fake_text_form_field.dart';

class DateFormField extends StatefulWidget {
  const DateFormField({
    Key key,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.autovalidate = false,
    this.decoration = const InputDecoration(),
    this.valueBuilder,
    this.validator,
  }) : super(key: key);

  final DateTime initialValue;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<DateTime> onSaved;
  final String Function(DateTime) valueBuilder;
  final FormFieldValidator<DateTime> validator;
  final InputDecoration decoration;
  final bool autovalidate;
  final bool enabled;

  @override
  DateFormFieldState createState() => DateFormFieldState();
}

class DateFormFieldState extends State<DateFormField> {
  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return FakeTextFormField<DateTime>(
      initialValue: _value,
      validator: widget.validator,
      decoration: widget.decoration,
      child: Builder(builder: (context) {
        if (_value == null) {
          return Text(widget.decoration.hintText ?? "Select a date");
        }

        return Text(widget.valueBuilder != null ? widget.valueBuilder(_value) : DateFormat.yMMMd().format(_value));
      }),
      onTap: widget.enabled ? showPicker() : null,
      onSaved: widget.onSaved,
    );
  }

  ValueChanged<FormFieldState<DateTime>> showPicker() {
    return (FormFieldState<DateTime> field) async {
      final value = await showDatePicker(
        context: context,
        initialDate: _value ?? clock.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
      );

      if (value == null || value == _value) {
        return;
      }

      setState(() {
        _value = value;
        field.didChange(value);
        if (widget.onChanged != null) {
          widget.onChanged(value);
        }
      });
    };
  }
}
