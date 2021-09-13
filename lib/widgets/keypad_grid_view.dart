import 'package:borome/constants.dart';
import 'package:borome/widgets.dart';
import 'package:flutter/material.dart';

class KeypadGridView extends StatelessWidget {
  const KeypadGridView({
    Key key,
    @required this.maxLength,
    @required this.controller,
  }) : super(key: key);

  final int maxLength;
  final ValueNotifier<String> controller;

  static final backSpaceIcon = Icons.backspace_outlined;
  static final defaultTextColor = AppColors.dark;
  static final defaultTextStyle = TextStyle(fontSize: 32.0, fontWeight: AppStyle.semibold);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 16 / 13,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0'].map((item) {
          if (item.isEmpty) {
            return SizedBox();
          }

          return TouchableOpacity(
            color: defaultTextColor,
            onPressed: () {
              if (controller.value.length < maxLength) {
                controller.value = '${controller.value}$item';
              }
            },
            child: Text('$item', style: defaultTextStyle),
          );
        }),
        TouchableOpacity(
          color: defaultTextColor,
          onPressed: () {
            if (controller.value.isNotEmpty) {
              controller.value = controller.value.substring(0, controller.value.length - 1);
            }
          },
          child: Text(
            String.fromCharCode(backSpaceIcon.codePoint),
            style: defaultTextStyle.copyWith(
              fontSize: defaultTextStyle.fontSize * 0.888889,
              height: 1,
              fontWeight: defaultTextStyle.fontWeight,
              fontFamily: backSpaceIcon.fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
