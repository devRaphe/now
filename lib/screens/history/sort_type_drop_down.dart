import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class SortTypeDropdown extends StatefulWidget {
  const SortTypeDropdown({
    Key key,
    @required this.initialValue,
    @required this.onChanged,
  }) : super(key: key);

  final SortType initialValue;
  final ValueChanged<SortType> onChanged;

  @override
  SortTypeDropdownState createState() => SortTypeDropdownState();
}

class SortTypeDropdownState extends State<SortTypeDropdown> {
  SortType dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: (dropdownValue ?? widget.initialValue).value,
      icon: Icon(Icons.keyboard_arrow_down, color: kHintColor),
      iconSize: IconTheme.of(context).size,
      elevation: 0,
      style: ThemeProvider.of(context).smallButton.copyWith(height: 1.24, color: kHintColor),
      underline: const SizedBox(),
      selectedItemBuilder: (BuildContext context) {
        return [
          for (int i = 0; i < SortType.values.length; i++)
            Row(
              children: [
                const Icon(AppIcons.filter, color: kTextBaseColor),
                const ScaledBox.horizontal(8),
                VerticalDivider(
                  indent: context.scaleY(10),
                  endIndent: context.scaleY(10),
                  color: kTextBaseColor,
                ),
                const ScaledBox.horizontal(8),
                Text(SortType.prettifiedValues[i]),
                const ScaledBox.horizontal(4),
              ],
            ),
        ];
      },
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = SortType.fromValue(newValue);
          widget.onChanged?.call(dropdownValue);
        });
      },
      items: [
        for (int i = 0; i < SortType.values.length; i++)
          DropdownMenuItem<String>(
            value: SortType.values[i],
            child: Text(SortType.prettifiedValues[i]),
          )
      ],
    );
  }
}
