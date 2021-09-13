import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/route_transition.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class DropDownFormField extends StatefulWidget {
  const DropDownFormField({
    Key key,
    @required this.items,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.valueBuilder,
    this.autovalidate = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String initialValue;
  final bool autovalidate;
  final String Function(String) valueBuilder;
  final List<String> items;
  final FormFieldSetter<String> onChanged;
  final InputDecoration decoration;

  @override
  DropDownFormFieldState createState() => DropDownFormFieldState();
}

class DropDownFormFieldState extends State<DropDownFormField> {
  GlobalKey<FakeTextFormFieldState> key = GlobalKey<FakeTextFormFieldState>();

  String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void cb(String value) {
    widget.onChanged?.call(value);
    setState(() => _value = value);
  }

  void clear() {
    key.currentState.clear();
    cb(_value);
  }

  void reset() {
    key.currentState.reset();
    cb(null);
  }

  @override
  void didUpdateWidget(DropDownFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.decoration.hintText ?? "Select...";

    return FakeTextFormField<String>(
      key: key,
      initialValue: _value,
      validator: widget.validator,
      decoration: widget.decoration,
      onSaved: widget.onSaved,
      child: Row(
        children: <Widget>[
          Expanded(
            child: DefaultTextStyle(
              style: context.theme.textfield,
              child: Builder(builder: (context) {
                if (_value == null) {
                  return Text(hintText, maxLines: 1, overflow: TextOverflow.ellipsis);
                }

                final value = widget.valueBuilder?.call(_value) ?? _value;
                return Text(value, maxLines: 1, overflow: TextOverflow.ellipsis);
              }),
            ),
          ),
          const ScaledBox.horizontal(4),
          Icon(Icons.keyboard_arrow_down, color: kHintColor),
        ],
      ),
      onTap: (FormFieldState<String> field) async {
        final value = await Navigator.of(context, rootNavigator: true).push<String>(
          RouteTransition.fadeIn(
            _Modal(
              title: hintText,
              items: widget.items,
              valueBuilder: widget.valueBuilder,
            ),
            fullscreenDialog: true,
          ),
        );

        if (value == null || value == _value) {
          return;
        }

        field.didChange(value);
        cb(value);
      },
    );
  }
}

class _Modal extends StatefulWidget {
  const _Modal({
    Key key,
    @required this.title,
    @required this.items,
    @required this.valueBuilder,
  }) : super(key: key);

  final String title;
  final List<String> items;
  final String Function(String) valueBuilder;

  @override
  __ModalState createState() => __ModalState();
}

class __ModalState extends State<_Modal> {
  TextEditingController inputController;

  @override
  void initState() {
    super.initState();

    inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ClearAppBar(
        child: Text(
          widget.title,
          style: ThemeProvider.of(context).subhead3.copyWith(fontWeight: AppStyle.light, letterSpacing: .35),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              hintText: "Search...",
              filled: false,
            ),
          ),
          const ScaledBox.vertical(8),
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: inputController,
              builder: (context, value, child) {
                final List<Pair<String, String>> items = widget.items
                    .where((item) => item.toLowerCase().contains(value.text.toLowerCase()))
                    .map((item) => Pair(item, widget.valueBuilder?.call(item) ?? item))
                    .toList();

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index].second,
                        style: ThemeProvider.of(context).bodySemi.copyWith(color: AppColors.dark),
                      ),
                      onTap: () => Navigator.pop<String>(context, items[index].first),
                    );
                  },
                  separatorBuilder: (_a, _b) => Divider(height: 0, indent: 10, endIndent: 10),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
