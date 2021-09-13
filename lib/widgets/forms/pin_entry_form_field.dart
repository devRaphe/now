import 'package:borome/utils.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class PinEntryFormField extends StatefulWidget {
  PinEntryFormField({
    Key key,
    this.length = 6,
    this.onFinished,
    this.initialValue = "",
    this.obscureText = false,
  })  : assert(length > 0),
        super(key: key);

  final int length;
  final FormFieldSetter<String> onFinished;
  final bool obscureText;
  final String initialValue;

  @override
  State createState() => PinEntryFormFieldState();
}

class PinEntryFormFieldState extends State<PinEntryFormField> {
  List<FocusNode> _focusNodes;
  List<TextEditingController> _controllers;
  List<String> _initialValues;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (i) => AlwaysDisabledFocusNode());
    _initializeControllers(widget.initialValue);

    var _values = List.filled(widget.length, "");
    for (var i = 0; i < widget.length; i++) {
      var controller = _controllers[i];
      controller.addListener(() {
        _values[i] = controller.text;
        if (i == widget.length - 1 && !_values.contains("") && widget.onFinished != null) {
          widget.onFinished(_values.join());
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant PinEntryFormField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _initializeControllers(widget.initialValue);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _initializeControllers(String initialValue) {
    _initialValues = List.generate(widget.length, (i) {
      if (i < initialValue.length) {
        return initialValue[i];
      }
      return "";
    });

    if (_controllers != null) {
      for (var i = 0; i < widget.length; i++) {
        _controllers[i].text = _initialValues[i];
      }
    } else {
      _controllers = List.generate(widget.length, (i) => TextEditingController(text: _initialValues[i]));
    }
  }

  @override
  void dispose() {
    _controllers?.forEach((ctrl) => ctrl.dispose());
    _focusNodes.forEach(
      (node) => node
        ..unfocus()
        ..dispose(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _spacing = ScaledBox.horizontal(8);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: ListUtils.withSeparator((index) => _buildInput(index), (index) => _spacing, widget.length),
    );
  }

  Widget _buildInput(int index) {
    return Expanded(
      child: TextField(
        controller: _controllers != null ? _controllers[index] : null,
        focusNode: _focusNodes[index],
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
            vertical: Theme.of(context).inputDecorationTheme.contentPadding.vertical / 2,
          ),
        ),
        cursorWidth: 0,
        style: ThemeProvider.of(context).display2,
        textAlign: TextAlign.center,
        maxLength: 1,
        scrollPadding: EdgeInsets.only(bottom: context.scaleY(40.0)),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
